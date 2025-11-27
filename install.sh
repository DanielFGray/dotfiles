#!/usr/bin/env bash

shopt -s nullglob

cd "${BASH_SOURCE%/*}" || exit
declare thisdir="$PWD"
declare verbose
declare -a errors
declare -a configs_avail
declare -a configs_chosen
declare -a specified_configs=()
declare all_flag=false
declare jobs=4
declare clone_proto=https
declare github_host="${GITHUB_HOST:-github.com}"
declare github_user="${GITHUB_USER:-danielfgray}"

source "./bash_utils"

if has nproc; then
  jobs=$(($(nproc) - 1))
fi

usage() {
  cat <<'EOF'
Usage: install.sh [OPTIONS] [CONFIGS...] [--all]

Install dotfiles and development tools.

OPTIONS:
  -h            Show this help message
  -v            Verbose output (show commands being run)
  -p JOBS       Number of parallel jobs (default: nproc-1)

ARGUMENTS:
  CONFIGS       Specific configuration names to install (space-separated)
  --all         Install all available configurations without prompting

ENVIRONMENT VARIABLES:
  GITHUB_HOST           GitHub hostname (default: github.com)  
  GITHUB_USER           GitHub username (default: danielfgray)

AVAILABLE CONFIGURATIONS:
EOF

  # Show available config functions
  compgen -A function | awk '/^config_/{ sub(/^config_/, "", $0); printf "  %-12s", $0; if (++count % 4 == 0) print ""; }'
  echo
  echo
  echo "Examples:"
  echo "  ./install.sh --all                    # Install everything"
  echo "  ./install.sh base vim zsh             # Install specific configs"
  echo "  ./install.sh -v base vim              # Install specific with verbose"
  echo "  ./install.sh -p 2 base vim zsh tmux   # Use 2 parallel jobs"
  echo "  FORCE_CLONE_PROTO=ssh ./install.sh --all  # Force SSH clones"
  echo
}
has_ssh_keys() {
  local ssh_keys
  ssh_keys=(~/.ssh/id_*)
  if ((${#ssh_keys[@]} > 0)); then
    clone_proto=ssh
  fi
}

err() {
  errors+=("  $*")
}

echo_cmd() {
  if ((verbose > 0)); then
    echo "$*"
    "$@" &>/dev/null
  else
    "$@" &>/dev/null
  fi
}

curl() {
  command curl -s "$@"
}
export -f curl

mkd() {
  mkdir ${verbose:+-v} -p "$@" || die 'failed to mkdir $*'
}

install_dots() {
  local f src dest
  for f; do
    src=$(realpath "${thisdir}/${f}")
    dest="$HOME/.${f}"
    if [[ ! -e "$src" ]]; then
      err "$src does not exist"
      break
    fi
    if [[ -e "$dest" && ! -L "$dest" ]]; then
      echo_cmd mv "$dest" "${dest%/*}/old-${dest##*/}"
    fi
    mkdir -p "${dest%/*}/"
    echo_cmd ln ${verbose:+-v} -s "$src" "$dest"
  done
}

library() {
  local repo path flags owner_repo
  flags=()
  if (($# < 2)); then
    err 'library() needs repo and path to clone to'
    return 1
  fi
  case "$1" in
  http* | https* | git* | ssh*) repo="$1" ;;
  *)
    owner_repo="$1"
    [[ "$owner_repo" != */* ]] && owner_repo="${github_user}/${owner_repo}"
    if [[ "$clone_proto" = ssh ]]; then
      repo="ssh://git@${github_host}/${owner_repo}"
    else
      repo="https://${github_host}/${owner_repo}.git"
    fi
    ;;
  esac
  path="$2"
  shift 2
  flags+=("$@")
  if [[ -d "$path" ]]; then
    if [[ -d "${path}/.git" ]]; then
      echo_cmd git -C "$path" pull
    else
      err "no .git found in ${path}, could not update"
    fi
  fi
  if [[ ! -d "$path" ]]; then
    mkd "${path%/*}"
    if ! echo_cmd git clone "${flags[@]}" "$repo" "$path"; then
      err "failed to clone $repo"
      return 1
    fi
  fi
}

config_base() {
  install_dots profile bashrc bash_aliases bash_utils inputrc gitconfig
}

config_scripts() {
  library bin ~/.local/bin
  library api-helper ~/build/api-helper
  library fzf-scripts ~/build/fzf-scripts
  library yaxg ~/build/yaxg
  mkd ~/.local/bin
  # Only link executables from directories that exist
  for build_dir in ~/build/{yaxg,fzf-scripts,api-helper}; do
    if [[ -d "$build_dir" ]]; then
      find "$build_dir" -maxdepth 1 -executable -type f -exec ln ${verbose:+-v} -s -t "$HOME/.local/bin" {} \; 2>/dev/null
    fi
  done
}

has vim && config_vim() {
  install_dots vimrc
  mkdir ${verbose:+-v} -p ~/.vim/{autoload,bundle,cache,undo,backups,swaps}
  curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall +qa &>/dev/null
}

has nvim && config_neovim() {
  mkdir -p ~/.config ~/.vim
  if [[ ! -e ~/.config/nvim ]]; then
    ln -s ~/.vim ~/.config/nvim
    ln -s "$(realpath ./nvim.lua)" ~/.config/nvim/init.lua
  fi
  if [[ -d ./nvim && ! -e ~/.config/nvim/lua ]]; then
    ln -s "$(realpath ./nvim)" ~/.config/nvim/lua
  fi
}

has zsh && config_zsh() {
  install_dots zshrc zshenv zlogin p10k.zsh
}

has fzf || config_fzf() {
  library https://github.com/junegunn/fzf.git ~/.fzf
  if [[ ! -x ~/.fzf/install ]]; then
    err 'failed to install fzf'
    return 1
  fi
  ~/.fzf/install --all &>/dev/null
}

has tmux && config_tmux() {
  install_dots tmux.conf
  library https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  [[ -x ~/.tmux/plugins/tpm/bin/install_plugins ]] && echo_cmd ~/.tmux/plugins/tpm/bin/install_plugins
}

has gem && config_gem() {
  install_dots gemrc
}

has X && config_x11() {
  has -v startx && install_dots xinitrc
  has -v xmodmap && install_dots xmodmap
  has -v xrdb && install_dots Xresources
  # if has -v fc-cache; then
  #   [[ -f ~/.local/share/fonts/FantasqueSansMono-Regular.ttf ]] && return 0
  #   mkdir -p ~/.local/share/fonts
  #   if [[ ! -f ~/downloads/fantasque-sans-mono.zip ]]; then
  #     echo_cmd curl -L --create-dirs -o ~/downloads/fantasque-sans-mono.zip \
  #       'https://fontlibrary.org/assets/downloads/fantasque-sans-mono/db52617ba875d08cbd8e080ca3d9f756/fantasque-sans-mono.zip'
  #   fi
  #   if ! has -v unzip; then
  #     err 'downloaded Fantasque Sans Mono but unzip is unavailable'
  #     return 1
  #   fi
  #   if [[ -f ~/downloads/fantasque-sans-mono.zip ]]; then
  #     echo_cmd unzip ~/downloads/fantasque-sans-mono.zip '*.ttf' -d ~/.local/share/fonts
  #   else
  #     err 'failed to download font Fantasque Sans Mono'
  #   fi
  # fi
}

has n || config_n() {
  echo_cmd curl -L https://bit.ly/n-install | bash
}

has bun || config_bun() {
  echo_cmd curl -fsSL https://bun.sh/install | bash
}

config() {
  has "config_$1" || {
    err ":: FAILED $1: does not exist"
    return 1
  }
  color blue ":: STARTING $1"
  if "config_$1"; then
    color green ":: FINISHED $1"
  else
    err ":: FAILED $1"
  fi
}

finish() {
  tput sgr0
  exit
}

trap finish SIGHUP SIGINT SIGTERM

while getopts ":hvp:" opt; do
  case "$opt" in
  h)
    usage
    exit
    ;;
  v) ((++verbose)) ;;
  p) jobs="$OPTARG" ;;
  esac
done
shift $((OPTIND - 1))
unset opt OPTARG OPTIND OPTERR

# Handle remaining arguments as config names or --all
for arg in "$@"; do
  if [[ "$arg" == "--all" ]]; then
    all_flag=true
  else
    specified_configs+=("$arg")
  fi
done

has_ssh_keys

mapfile -t configs_avail < <(compgen -A function | awk '/^config_/{ sub(/^config_/, "", $0); print }')

if [[ "$all_flag" == true ]]; then
  configs_chosen=("${configs_avail[@]}")
elif ((${#specified_configs[@]} > 0)); then
  # Validate specified configs exist
  for config in "${specified_configs[@]}"; do
    if [[ " ${configs_avail[*]} " =~ " ${config} " ]]; then
      configs_chosen+=("$config")
    else
      err "Unknown configuration: $config"
    fi
  done
elif ! in_term; then
  configs_chosen=("${configs_avail[@]}")
else
  # Interactive prompt (existing behavior)
  printf 'will install the following groups:\n'
  read -r -e -p '> ' -i "${configs_avail[*]}" -a configs_chosen
fi

((${#configs_chosen[@]} > 0)) || die

for f in "${configs_chosen[@]}"; do
  ((count++ >= jobs)) && wait -n
  config "$f" &
done
wait

if (("${#errors[@]}" > 0)); then
  color red 'The following errors occured'
  color red "${errors[@]}"
else
  color green 'success!'
fi

finish
