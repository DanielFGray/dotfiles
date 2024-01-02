local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' ' -- 'vim.g' sets global variables
vim.g.loaded_netrwPlugin = 1

require('lazy').setup({
  -- utils/commands/maps
  { 'https://github.com/nvim-telescope/telescope.nvim',
    dependencies = {
      'https://github.com/nvim-lua/plenary.nvim',
      -- 'https://github.com/joaomsa/telescope-orgmode.nvim',
      -- 'https://github.com/ThePrimeagen/refactoring.nvim',
    },
    tag = '0.1.4',
    keys = {
      { '<Leader>/', function() require('telescope.builtin').live_grep() end, desc = 'Live Grep', mode = 'n', silent = true },
      { '<Leader>b', function() require('telescope.builtin').buffers() end, desc = 'List buffers', mode = 'n', silent = true },
      { '<Leader>;', function() require('telescope.builtin').commands() end, desc = 'List commands', mode = 'n', silent = true },
      { '<Leader>ff', function() require('telescope.builtin').find_files() end, desc = 'List project files', mode = 'n', silent = true },
      { '<Leader>fr', function() require('telescope.builtin').oldfiles() end, desc = 'List recent files', mode = 'n', silent = true },
      { '<Leader><space>', function() require('telescope.builtin').keymaps() end, desc = 'List keymaps', mode = 'n', silent = true },
      -- { '<leader>crr', "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", desc = 'List refactoring methods' , mode = 'v', silent = true }
    },
    cmd = { 'Telescope' },
    opts = {
      defaults = {
        vimgrep_arguments = { 'rg', '-L', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' },
        prompt_prefix = '   ',
        selection_caret = ' ',
        file_ignore_patterns = { 'node_modules' },
        path_display = { 'truncate' },
      },
    },
  },
  { 'https://github.com/jebaum/vim-tmuxify',                                   -- tmux integration
    init = function()
      vim.g.tmuxify_map_prefix = '<Leader>x'
      vim.g.tmuxify_custom_command = 'tmux splitw -dv -p25'
      vim.g.tmuxify_global_maps = 1
      vim.g.tmuxify_run = {
        lilypond =   ' f="%"; lilypond "$f" && x-pdf "${f/%ly/pdf}"; unset f',
        tex =        ' f="%"; texi2pdf "$f" && x-pdf "${f/%tex/pdf}"; unset f',
        ruby =       ' ruby %',
        python =     ' python %',
        typescript = ' ts-node %',
        javascript = ' node %',
      }
    end,
  },
  'https://github.com/vim-utils/vim-husk',                                     -- readline command maps
  'https://github.com/tpope/vim-abolish',                                      -- extended subsititions and replacements `:S :Ab`
  'https://github.com/tpope/vim-eunuch',                                       -- simple commands for common linux tasks
  'https://github.com/tpope/vim-sleuth',                                       -- better indent/buffer type detection
  { 'https://github.com/tpope/vim-unimpaired',                                 -- lots of keybinds `[e ]b yox`
    keys = { '[', ']', 'yo', '<', '>', '=' },
  },
  'https://github.com/tpope/vim-dotenv',                                       -- make .env vars accessible
  'https://github.com/tpope/vim-fugitive',                                     -- git integration
  'https://github.com/haya14busa/is.vim',                                      -- better incsearch highlighting
  'https://github.com/chrisbra/NrrwRgn',                                       -- `:NR` edits selected regions in separate buffer
  'https://github.com/zx2c4/password-store',                                   -- disable viminfo etc for files in ~/.password-store
  { 'https://github.com/nvim-treesitter/nvim-treesitter',                      -- highlighting driven by syntax parsers
    event = { 'BufReadPre', 'BufNewFile' },
    lazy = true,
    dependencies = {
      'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
      'https://github.com/RRethy/nvim-treesitter-endwise',
      'https://github.com/andymass/vim-matchup',
      'https://github.com/windwp/nvim-ts-autotag',
      'https://github.com/JoosepAlviste/nvim-ts-context-commentstring',
    },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'bash',
          'c',
          'clojure',
          'cmake',
          'cpp',
          'css',
          'dockerfile',
          'gitignore',
          'graphql',
          'haskell',
          'html',
          'javascript',
          'json',
          'json5',
          'jsonc',
          'lua',
          'make',
          'markdown',
          'markdown_inline',
          'org',
          'perl',
          'python',
          'regex',
          'rust',
          'sql',
          'tsx',
          'typescript',
          'vim',
          'vimdoc',
          'yaml',
        },
        auto_install = true,
        highlight = { enabled = true },
        indent = { enable = true },
        endwise = { enable = true },
        matchup = { enable = true, },
        autotag = { enable = true },
        textobjects = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
          },
        },
      })
    end,
  },
  { 'https://github.com/folke/neodev.nvim',
    config = true,
    ft = 'lua',
  },
  { 'https://github.com/stevearc/stickybuf.nvim',
    opts = {},
  },

  -- LSP
  { 'https://github.com/VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    lazy = true,
    config = function()
      -- This is where you modify the settings for lsp-zero
      -- Note: autocompletion settings will not take effect
      require('lsp-zero.settings').preset({
        name = 'minimal',
        set_lsp_keymaps = false,
        manage_nvim_cmp = true,
        suggest_lsp_servers = true,
      })
    end
  },
  { 'https://github.com/j-hui/fidget.nvim',
    tag = 'legacy',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      text = {
        spinner = 'dots_negative',
      },
      timer = {
        spinner_rate = 150,
      },
    },
  },
  { 'https://github.com/hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'https://github.com/hrsh7th/cmp-nvim-lsp',
      'https://github.com/hrsh7th/cmp-buffer',
      'https://github.com/hrsh7th/cmp-path',
      'https://github.com/saadparwaiz1/cmp_luasnip',
      'https://github.com/hrsh7th/cmp-nvim-lua',
      { 'https://github.com/L3MON4D3/LuaSnip',
        dependencies = { 'https://github.com/rafamadriz/friendly-snippets' },
        build = 'make install_jsregexp',
      },
      'https://github.com/onsails/lspkind.nvim',
      { 'https://github.com/roobert/tailwindcss-colorizer-cmp.nvim',
        opts = {
          color_square_width = 2,
        },
      },
      { 'https://github.com/zbirenbaum/copilot-cmp',
        dependencies = { 'https://github.com/zbirenbaum/copilot.lua',
          cmd = "Copilot",
          event = "InsertEnter",
          opts = {
            suggestion = { enabled = false },
            panel = {
              enabled = true,
              auto_refresh = true,
            },
          },
        },
        opts = true,
      },
    },
    config = function()
      require('lsp-zero.cmp').extend({
        use_luasnip = true,
        set_format = true,
        set_sources = 'recommended'
      })
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero.cmp').action()
      cmp.setup({
        formatting = {
          format = function(entry, item)
            require('lspkind').cmp_format({
              mode = 'symbol',
              symbol_map = { Copilot = '' },
            })(entry, item)
            return require('tailwindcss-colorizer-cmp').formatter(entry, item)
          end,
        },
        sources = {
          { name = 'copilot' },
          { name = 'orgmode' },
          { name = 'path' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'nvim_lua' },
          { name = 'buffer' },
        },
        mapping = {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-o>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp_action.luasnip_supertab(),
          ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-y>'] = cmp_action.luasnip_jump_forward(),
          ['<C-n>'] = cmp_action.luasnip_jump_backward(),
        }
      })
    end
  },
  { 'https://github.com/neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- 'https://github.com/jinzhongjia/LspUI.nvim',
      { 'https://github.com/glepnir/lspsaga.nvim',
        after = 'nvim-lspconfig',
        dependencies = {
          'https://github.com/nvim-tree/nvim-web-devicons',
          'https://github.com/nvim-treesitter/nvim-treesitter'
        },
      },
      'https://github.com/hrsh7th/cmp-nvim-lsp',
      'https://github.com/williamboman/mason-lspconfig.nvim',
      {
        'https://github.com/williamboman/mason.nvim',
        cmd = 'Mason',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'https://github.com/jose-elias-alvarez/null-ls.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
          'https://github.com/CKolkey/ts-node-action',
          'https://github.com/jay-babu/mason-null-ls.nvim',
          'https://github.com/nvim-lua/plenary.nvim',
          { 'https://github.com/jose-elias-alvarez/typescript.nvim', config = true },
        },
      },
      { 'https://github.com/ThePrimeagen/refactoring.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
          'https://github.com/nvim-lua/plenary.nvim',
          'https://github.com/nvim-treesitter/nvim-treesitter'
        },
        opts = {},
        -- keys = {
        --   -- Remaps for the refactoring operations currently offered by the plugin
        --   { '<leader>cre', function() require('refactoring').refactor('Extract Function') end, desc = 'Extract function', mode = 'v', silent = true, expr = false },
        --   { '<leader>crf', function() require('refactoring').refactor('Extract Function To File') end, desc = 'Extract function to file', mode = 'v', silent = true, expr = false },
        --   { '<leader>crv', function() require('refactoring').refactor('Extract Variable') end, desc = 'Extract variable', mode = 'v', silent = true, expr = false },
        --   { '<leader>cri', function() require('refactoring').refactor('Inline Variable') end, desc = 'Inline variable', mode = 'v', silent = true, expr = false },
        --   -- Extract block doesn't need visual mode
        --   { '<leader>crb', function() require('refactoring').refactor('Extract Block') end, desc = 'Extract block', mode = 'n', silent = true, expr = false },
        --   { '<leader>crbf', function() require('refactoring').refactor('Extract Block To File') end, desc = 'Extract block to file', mode = 'n', silent = true, expr = false },
        --   -- Inline variable can also pick up the identifier currently under the cursor without visual mode
        --   { '<leader>cri', function() require('refactoring').refactor('Inline Variable') end, desc = 'Inline variable', mode = 'n', silent = true, expr = false },
        -- },
      },
    },
    config = function()
      local lsp = require('lsp-zero')
      -- local LspUI = require('LspUI')
      -- LspUI.setup({
      --   code_action = {
      --     icon = '',
      --     keybind = {
      --       exec = '<CR>',
      --       prev = 'k',
      --       next = 'j',
      --       quit = '<esc>',
      --     },
      --   }
      -- })
      require('lspsaga').setup({
        lightbulb = {
          enable = false,
        },
        symbol_in_winbar = {
          enable = false,
        },
        ui = {
          title = true,
          border = 'single',
          winblend = 10,
          expand = '',
          collapse = '',
          code_action = '',
          incoming = ' ',
          outgoing = ' ',
          hover = ' ',
          kind = {},
        },
        rename = {
          title = true,
          border = 'single',
        },
      })
      lsp.on_attach(function(client, bufnr)
        -- vim.keymap.set('n', '<leader>crn', LspUI.api.rename, { buffer = bufnr, desc = 'Rename Symbol', silent = true })
        -- vim.keymap.set('n', '<leader>cc', LspUI.api.code_action, { buffer = bufnr, desc = 'Code Action' , silent = true })
        -- vim.keymap.set('n', 'gD', LspUI.api.peek_definition, { buffer = bufnr, desc = 'Go to Declaration', silent = true })
        vim.keymap.set('n', '<leader>crn', "<cmd>Lspsaga rename<CR>", { buffer = bufnr, desc = 'Rename Symbol', silent = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>cc', '<cmd>Lspsaga code_action<CR>', { buffer = bufnr, desc = 'Code Action' , silent = true })
        vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { buffer = bufnr, desc = 'Show Diagnostics', silent = true })
        vim.keymap.set('n', 'K', "<Cmd>Lspsaga hover_doc<CR>", { buffer = bufnr, desc = 'Show Hover', silent = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>cf', function() vim.lsp.buf.format({ async = true }) end, { buffer = bufnr, desc = 'Format' , silent = true })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to Definition', silent = true })
        vim.keymap.set('n', 'gD', '<cmd>Lspsaga peek_type_definition<CR>', { buffer = bufnr, desc = 'Go to Declaration', silent = true })
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Go to Implementaion', silent = true })
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = bufnr, desc = 'Previous Diagnostic', silent = true })
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = bufnr, desc = 'Next Diagnostic', silent = true })
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Show Hover', silent = true })
        -- vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'Go to Type Definition', silent = true })
        -- vim.keymap.set('n', '<Ctrl-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Help', silent = true })
        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
          vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
          vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Clear All the References",
          })
          vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Document Highlight",
          })
          vim.api.nvim_create_autocmd("CursorHoldI", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Document Highlight",
          })
        end
      end)
      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
      lsp.setup()
      require('mason').setup({
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = ' ',
          },
        },
      })
      require('mason-null-ls').setup({
        ensure_installed = {
          'astro-language-server',
          'bash-language-server',
          'css-lsp',
          'docker-compose-language-service',
          'dockerfile-language-server',
          'emmet-ls',
          'gopls',
          'graphql-language-service-cli',
          'html-lsp',
          'json-lsp',
          'lua-language-server',
          'prettierd',
          'tailwindcss-language-server',
          'typescript-language-server',
        },
        automatic_installation = true,
        handlers = {},
      })
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          require('typescript.extensions.null-ls.code-actions'),
          null_ls.builtins.code_actions.ts_node_action,
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.formatting.prettierd.with({
            -- prefer_local = 'node_modules/.bin',
            condition = function(utils)
              return utils.root_has_file({
                '.prettierrc',
                '.prettierrc.json',
                '.prettierrc.json5',
                '.prettierrc.js',
                '.prettierrc.cjs',
                'prettier.config.js',
                'prettier.config.cjs',
              })
            end
          }),
          -- null_ls.builtins.diagnostics.eslint_d.with({
          --   diagnostics_format = '[eslint] #{m}\n(#{c})',
          --   condition = function(utils)
          --     return utils.root_has_file({
          --       '.eslintrc.js',
          --       '.eslintrc.cjs',
          --       '.eslintrc.json',
          --     })
          --   end
          -- }),
          -- null_ls.builtins.formatting.eslint_d,
          -- null_ls.builtins.code_actions.eslint_d,
        },
      })
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          border = 'single',
        },
        virtual_lines = {
          only_current_line = true,
          spacing = 1,
        },
      })
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {
          silent = true,
          border = false,
        }
      )
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {
          border = 'single',
        }
      )
    end
  },
  { 'https://github.com/folke/trouble.nvim',
    dependencies = 'https://github.com/nvim-tree/nvim-web-devicons',
    opts = {
      use_diagnostic_signs = true
    },
    cmd = { 'TroubleToggle', 'Trouble' },
    keys = {
      { 'gr', '<cmd>TroubleToggle lsp_references<cr>', desc = 'Show References', mode = 'n', silent = true }
    },
  },

  -- operators
  'https://github.com/tpope/vim-repeat',                                       -- enables repeat `.` for plugins
  'https://github.com/tpope/vim-commentary',                                   -- toggle comments `gc<motion>`
  'https://github.com/tpope/vim-surround',                                     -- manage surrounding pairs `ds.. cs.. ys..`
  'https://github.com/tommcdo/vim-exchange',                                   -- swap selections `cx<motion>` in normal `X` in visual
  'https://github.com/AndrewRadev/splitjoin.vim',                              -- smarter `gJ` joins and split with `gS`
  'https://github.com/tpope/vim-speeddating',                                  -- ctrl-x/a works on dates
  'https://github.com/Konfekt/vim-CtrlXA',                                     -- ctrl-x/a works on other stuff
  'https://github.com/christoomey/vim-titlecase',                              -- Title Case mappings
  -- { 'https://github.com/echasnovski/mini.align',
  --   version = '*',
  --   opts = true,
  -- },
  { 'https://github.com/junegunn/vim-easy-align',                              -- automatic visual alignments
    keys = {
      { 'ga', '<Plug>(EasyAlign)', mode = { 'n', 'x' }, desc = 'Align text', silent = true }
    },
  },
  { 'https://github.com/dahu/Insertlessly',                                    -- insert newline with enter
    init = function()
      vim.g.insertlessly_insert_newlines = 1
      vim.g.insertlessly_open_newlines = 0
      vim.g.insertlessly_backspace_past_bol = 1
      vim.g.insertlessly_delete_at_eol_joins = 1
      vim.g.insertlessly_insert_spaces = 0
      vim.g.insertlessly_cleanup_trailing_ws = 0
      vim.g.insertlessly_cleanup_all_ws = 0
      vim.g.insertlessly_adjust_cursor = 1
    end,
  },

  -- motions
  { 'https://github.com/justinmk/vim-sneak',                                   -- linewise `fFtT;,` and two char sneak `s.. S..`
    keys = {
      { 's', '<Plug>Sneak_s', desc = 'Sneak forwards' },
      { 'S', '<Plug>Sneak_S', desc = 'Sneak backwards' },
      { 'f', '<Plug>Sneak_f', desc = 'Move to next char' },
      { 'F', '<Plug>Sneak_F', desc = 'Move to previous char'  },
      { 't', '<Plug>Sneak_t', desc = 'Move before next char' },
      { 'T', '<Plug>Sneak_T', desc = 'Move before previous char' },
      { 'z', '<Plug>Sneak_s', desc = 'Sneak forwards', mode = 'o' },
      { 'Z', '<Plug>Sneak_S', desc = 'Sneak backwards', mode = 'o' },
      { ';', '<Plug>SneakNext' },
      { ',', '<Plug>SneakPrevious' },
    },
  },
  { 'https://github.com/haya14busa/vim-asterisk',                              -- improved * search
    keys = {
      { '*', '<Plug>(asterisk-z*)<Plug>(is-nohl-1)' },
      { '#', '<Plug>(asterisk-z#)<Plug>(is-nohl-1)' },
      { 'g*', '<Plug>(asterisk-gz*)<Plug>(is-nohl-1)' },
      { 'g#', '<Plug>(asterisk-gz#)<Plug>(is-nohl-1)' },
    },
  },
  { 'https://github.com/andymass/vim-matchup',                                 -- extended `%` jumping
    keys = { '%' },
  },
  'https://github.com/wellle/targets.vim',                                     -- extended motions `vin)`
  { 'https://github.com/kana/vim-textobj-indent',                              -- indent textobj `vii`
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'https://github.com/kana/vim-textobj-user' }              -- custom textobj engine, more textobj: https://github.com/kana/vim-textobj-user/wiki
  },
  { 'https://github.com/glts/vim-textobj-comment',                             -- comment textobj `vac`
    dependencies = { 'https://github.com/kana/vim-textobj-user' },
  },

  -- UI
  { "https://github.com/utilyre/barbecue.nvim",
    name = "barbecue",
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      "https://github.com/SmiteshP/nvim-navic",
      "https://github.com/nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = true,
  },
  { 'https://github.com/nvim-lualine/lualine.nvim',                            -- fancy statusline
    event = 'VeryLazy',
    dependencies = {
      'https://github.com/nvim-tree/nvim-web-devicons',
      -- 'https://github.com/SmiteshP/nvim-navic',
      'https://github.com/jcdickinson/wpm.nvim',
      -- 'https://github.com/arkav/lualine-lsp-progress',
    },
    config = function()
      -- local navic = require('nvim-navic')
      -- navic.setup({
      --   highlight = true,
      --   separator = '  ',
      --   -- separator = '  ',
      --   lsp = {
      --     auto_attach = true,
      --   },
      -- })
      local wpm = require("wpm")
      wpm.setup({})
      require('lualine').setup({
        options = {
          disabled_filetypes = { statusline = { 'alpha' } },
          globalstatus = true,
        },
        extensions = {
          'fzf',
          'fugitive',
          'nvim-tree',
          'neo-tree',
          'lazy',
        },
        sections = {
          lualine_c = {
            'filename',
          },
          lualine_x = {
            function()
              return wpm.wpm() .. ' wpm' .. ' ' .. wpm.historic_graph()
            end
          },
          lualine_y = { 'encoding', 'fileformat' },
          lualine_z = { 'filetype' }
        },
      })
    end,
  },
  { 'https://github.com/romgrk/barbar.nvim',
    dependencies = {
      'https://github.com/lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'https://github.com/nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    keys = {
      { '[b', '<Cmd>BufferPrevious<CR>', desc = 'Previous buffer in bar list', mode = 'n', silent = true },
      { ']b', '<Cmd>BufferNext<CR>', desc = 'Next buffer in bar list', mode = 'n', silent = true },
      { '[B', '<Cmd>BufferMovePrevious<CR>', desc = 'Next buffer in bar list', mode = 'n', silent = true },
      { ']B', '<Cmd>BufferMoveNext<CR>', desc = 'Next buffer in bar list', mode = 'n', silent = true },
    },
    opts = {
      hide = { extensions = true },
      sidebar_filetypes = {
        NvimTree = true,
        undotree = {text = 'undotree'},
        ['neo-tree'] = {event = 'BufWipeout'},
      },
    },
  },
  { 'https://github.com/nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'https://github.com/nvim-lua/plenary.nvim',
      'https://github.com/nvim-tree/nvim-web-devicons',
      'https://github.com/MunifTanjim/nui.nvim',
      { 'https://github.com/miversen33/netman.nvim',
        opts = true,
      },
    },
    lazy = true,
    keys = {
      { '-', '<Cmd>Neotree focus filesystem right reveal_force_cwd<CR>', desc = 'Show file in filetree', mode = 'n', silent = true },
    },
    commands = { 'Neotree' },
    opts = {
      follow_current_file = { enabled = true },
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = false,
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
      sources = {
        'filesystem',
        'buffers',
        'document_symbols',
        'git_status',
        'netman.ui.neo-tree',
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function(file_path)
            require("neo-tree.command").execute({ action = "close" })
          end
        },
      },
      document_symbols = {
        follow_cursor = false,
        kinds = {
          File = { icon = '󰈙', hl = 'Tag' },
          Namespace = { icon = '󰌗', hl = 'Include' },
          Package = { icon = '󰏖', hl = 'Label' },
          Class = { icon = '󰌗', hl = 'Include' },
          Property = { icon = '󰆧', hl = '@property' },
          Enum = { icon = '󰒻', hl = '@number' },
          Function = { icon = '󰊕', hl = 'Function' },
          String = { icon = '󰀬', hl = 'String' },
          Number = { icon = '󰎠', hl = 'Number' },
          Array = { icon = '󰅪', hl = 'Type' },
          Object = { icon = '󰅩', hl = 'Type' },
          Key = { icon = '󰌋', hl = '' },
          Struct = { icon = '󰌗', hl = 'Type' },
          Operator = { icon = '󰆕', hl = 'Operator' },
          TypeParameter = { icon = '󰊄', hl = 'Type' },
          StaticMethod = { icon = '󰠄 ', hl = 'Function' },
        }
      },
      -- Add this section only if you've configured source selector.
      source_selector = {
        -- winbar = true,
        statusline = false,
        sources = {
          { source = 'document_symbols', display_name = ' 󰌗 Symbols ' },
          { source = 'filesystem', display_name = ' 󰉓 Files ' },
          { source = 'buffers', display_name = ' 󰉓 Buffers ' },
          { source = 'git_status', display_name = ' 󰊢 Git ' },
        },
      },
      filesystem = {
        hijack_netrw_behavior = 'open_default',
        window = {
          mappings = {
              ['-'] = 'navigate_up',
          },
        },
      },
      default_component_configs = {
        container = {
          enable_character_fade = true
        },
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          -- indent guides
          with_markers = true,
          indent_marker = '│',
          last_indent_marker = '└',
          highlight = 'NeoTreeIndentMarker',
          -- expander config, needed for nesting files
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        icon = {
          folder_closed = '',
          folder_open = '',
          folder_empty = '󰜌',
          -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
          -- then these will never be used.
          default = '*',
          highlight = 'NeoTreeFileIcon'
        },
        modified = {
          symbol = '[+]',
          highlight = 'NeoTreeModified',
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = 'NeoTreeFileName',
        },
        git_status = {
          symbols = {
            -- Change type
            added     = '', -- or '✚', but this is redundant info if you use git_status_colors on the name
            modified  = '', -- or '', but this is redundant info if you use git_status_colors on the name
            deleted   = '✖',-- this can only be used in the git_status source
            renamed   = '󰁕',-- this can only be used in the git_status source
            -- Status type
            untracked = '',
            ignored   = '',
            unstaged  = '󰄱',
            staged    = '',
            conflict  = '',
          }
        },
        -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
        file_size = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        type = {
          enabled = true,
          required_width = 122, -- min width of window required to show this column
        },
        last_modified = {
          enabled = true,
          required_width = 88, -- min width of window required to show this column
        },
        created = {
          enabled = true,
          required_width = 110, -- min width of window required to show this column
        },
        symlink_target = {
          enabled = false,
        },
      },
    },
  },
  'https://github.com/noahfrederick/vim-noctu',                                -- a simple terminal-based theme
  { 'https://github.com/flazz/vim-colorschemes',                               -- lots of colorschemes
    priority = 100,
  },
  'https://github.com/markonm/traces.vim',                                     -- visual substitution highlight
  { 'https://github.com/junegunn/goyo.vim',                                    -- fences in current buffer with extra windows
    keys = {
      { '<Leader>tG', '<Cmd>Goyo<CR>', desc = 'Toggle Goyo', mode = 'n', silent = true },
    },
  },
  { 'https://github.com/junegunn/limelight.vim',                               -- helps focus on current paragraph
    cmd = { 'Limelight' },
    lazy = true,
    init = function()
      vim.g.limelight_conceal_ctermfg = 'black'
    end,
    keys = {
      { '<Leader>tl', '<Cmd>Limelight!!<CR>', mode = 'n', desc = 'Toggle limelight', silent = true },
    },
  },
  { 'https://github.com/DanielFGray/DistractionFree.vim',                      -- toggle UI elements
    keys = {
      { '<Leader>td', '<Cmd>DistractionsToggle<CR>', desc = 'Toggle distractions', mode = 'n', silent = true },
    },
  },
  { 'https://github.com/anuvyklack/pretty-fold.nvim',                          -- prettier/configurable folds
    opts = {
      keep_indentation = true,
      fill_char = ' ',
      process_comment_signs = true,
    },
  },
  { 'https://github.com/goolord/alpha-nvim',                                   -- fancy startup screen
    dependencies = { 'https://github.com/nvim-tree/nvim-web-devicons' },
    config = function()
      require'alpha'.setup(require'alpha.themes.startify'.config)
    end,
  },
  { 'https://github.com/folke/which-key.nvim',                                 -- visual keybind navigator
    dependencies = { 'https://github.com/afreakk/unimpaired-which-key.nvim' },
    keys = { '<leader>', '[', ']', 'g', 'v', 'c', 'd', 'y', '"', 'z', '<C-w>', '=', '@' },
    config = function()
      local wk = require('which-key')
      local uwk = require('unimpaired-which-key')
      wk.setup({
        key_labels = {
          ['<CR>'] = '',
          ['<Plug>'] = '',
        },
        -- window = {
        --   winblend = 12
        -- },
      })
      wk.register({
        d = 'db',
        e = 'edit',
        f = 'files',
        g = 'git',
        n = 'narrow',
        c = {
          'code',
          r = 'refactor',
        },
        t = 'toggles/tabs',
        x = 'tmux',
      }, { prefix = '<leader>' })
      wk.register(uwk.normal_mode)
      wk.register(uwk.normal_and_visual_mode, { mode = { 'n', 'v' } })
    end,
  },
  { 'https://github.com/lewis6991/gitsigns.nvim',                              -- git markers
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      current_line_blame = false,
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      preview_config = {
        border = 'single',
      },
      -- word_diff = true,
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')
        vim.keymap.set('n', '[g', gitsigns.prev_hunk, { buffer = bufnr, desc = 'Jump to previous hunk' })
        vim.keymap.set('n', ']g', gitsigns.next_hunk, { buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
        vim.keymap.set('n', '<leader>gu', gitsigns.undo_stage_hunk, { buffer = bufnr, desc = 'Undo stage hunk' })
        vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
        vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer, { buffer = bufnr, desc = 'Reset buffer' })
        vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { buffer = bufnr, desc = 'Preview hunk' })
        vim.keymap.set('n', '<leader>gb', gitsigns.blame_line, { buffer = bufnr, desc = 'Show blame information' })
        vim.keymap.set('n', '<leader>gS', gitsigns.stage_buffer, { buffer = bufnr, desc = 'Stage entire buffer' })
        vim.keymap.set('n', '<leader>gD', gitsigns.diffthis, { buffer = bufnr, desc = 'Diff buffer' })
        vim.keymap.set('n', '<leader>gT', gitsigns.toggle_current_line_blame, { buffer = bufnr, desc = 'Toggle current blame' })
        vim.keymap.set('n', '<leader>gd', gitsigns.toggle_deleted, { buffer = bufnr, desc = 'Toggle deleted' })
      end,
    },
  },
  { 'https://github.com/mbbill/undotree',                                      -- visual undo tree
    keys = {
      { '<Leader>u', '<Cmd>UndotreeToggle<CR>', desc = 'Toggle undotree window', mode = 'n', silent = true },
    },
    config = function()
      vim.g.undotree_WindowLayout = 4
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_SplitWidth = 60
      vim.g.Undotree_CustomMap = function()
        vim.keymap.set('n', 'k', '<Plug>UndotreeGoNextState', { buffer = true, silent = true })
        vim.keymap.set('n', 'j', '<Plug>UndotreeGoPreviousState', { buffer = true, silent = true })
        vim.keymap.set('n', '<Esc>', '<Plug>UndotreeClose', { buffer = true, silent = true })
      end
    end,
  },
  { 'https://github.com/TimUntersberger/neogit',                               -- git integration
    dependencies = {
      'https://github.com/nvim-lua/plenary.nvim',
      'https://github.com/sindrets/diffview.nvim'
    },
    cmd = { 'Neogit' },
    opts = {
      kind = 'split',
      -- Persist the values of switches/options within and across sessions
      remember_settings = true,
      -- Scope persisted settings on a per-project basis
      use_per_project_settings = false,
      -- Array-like table of settings to never persist. Uses format 'Filetype--cli-value'
      --   ie: `{ 'NeogitCommitPopup--author', 'NeogitCommitPopup--no-verify' }`
      ignored_settings = {},
      -- Change the default way of opening the commit popup
      commit_popup = {
        kind = 'split',
      },
      -- Change the default way of opening the preview buffer
      preview_buffer = {
        kind = 'split',
      },
      -- Change the default way of opening popups
      popup = {
        kind = 'split',
      },
      -- customize displayed signs
      signs = {
        -- { CLOSED, OPENED },
        section = { '󰜴', '󰜮' },
        item = { '󰜴', '󰜮' },
        hunk = { '', '' },
      },
      integrations = {
        diffview = false
      },
      -- Setting any section to `false` will make the section not render at all
      sections = {
        -- untracked = { folded = false },
        -- unstaged = { folded = false },
        -- staged = { folded = false },
        -- stashes = { folded = true },
        -- unpulled = { folded = true },
        -- unmerged = { folded = false },
        -- recent = { folded = true },
      },
      -- override/add mappings
      mappings = {
        -- modify status buffer mappings
        -- status = {
        --   -- Adds a mapping with 'B' as key that does the 'BranchPopup' command
        --   ['B'] = 'BranchPopup',
        --   -- Removes the default mapping of 's'
        --   ['s'] = '',
        -- },
      },
    },
  },
  { 'https://github.com/hkupty/iron.nvim',                                     -- interactive repl
    config = true,
    lazy = true,
  },
  { 'https://github.com/kristijanhusak/vim-dadbod-ui',                         -- UI for interacting with a db
    dependencies = {
      'https://github.com/tpope/vim-dispatch',
      'https://github.com/tpope/vim-dadbod',
    },
    keys = {
      { '<Leader>db', '<Cmd>DBUIToggle<CR>', desc = 'open DB UI', mode = 'n', silent = true },
      { '<Leader>db', "<Cmd>'<,'>DB<CR>", desc = 'execute code', mode = 'x', silent = true },
    },
    init = function()
      vim.g.db_ui_env_variable_url = 'DATABASE_URL'
      vim.g.db_ui_hide_schemas = { 'migrations', 'information_schema', 'pg_catalog' }
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_table_helpers = {
        postgresql = {
          Count = 'SELECT count(*) FROM {optional_schema}{table}',
          Explain = 'EXPLAIN ANALYZE\n{last_query}',
        },
      }
    end,
  },
  { 'https://github.com/cshuaimin/ssr.nvim',
    keys = {
      { '<Leader><C-s>', function() require('ssr').open() end, mode = { 'n', 'x' }, desc = 'Structural replace', silent = true },
    },
    opts = {
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      keymaps = {
        close = 'q',
        next_match = 'n',
        prev_match = 'N',
        replace_confirm = '<CR>',
        replace_all = '<Leader><CR>',
      },
    },
  },
  { 'https://github.com/gorbit99/codewindow.nvim',                             -- minimap
    keys = {
      { '<Leader>tm', function() require('codewindow').toggle_minimap() end, mode = 'n', desc = 'Toggle minimap', silent = true }
    },
    config = function()
      require('codewindow').setup({
        exclude_filetypes = { 'help', 'NvimTree', 'Trouble' },
        window_border = 'single',
      })
      vim.api.nvim_set_hl(0, 'CodewindowBackground', { bg = '#222730' })
      -- vim.api.nvim_set_hl(0, 'CodewindowError', { bg = '#ff0000' })
      -- vim.api.nvim_set_hl(0, 'CodewindowWarn', { bg = '#ebcb8b' })
      -- CodewindowAddition -- the color of the addition git sign
      -- CodewindowDeletion -- the color of the deletion git sign
      -- CodewindowUnderline -- the color of the underlines on the minimap
    end
  },
  { 'https://github.com/nvim-orgmode/orgmode',
    ft = 'org',
    dependencies =  {
      { 'https://github.com/lukas-reineke/headlines.nvim',
        dependencies = 'https://github.com/nvim-treesitter/nvim-treesitter',
        config = true, -- or `opts = {}`
      },
      { 'https://github.com/michaelb/sniprun',
        build = 'sh ./install.sh'
      },
      { 'https://github.com/akinsho/org-bullets.nvim',
        opts = true,
      },
    },
    config = function()
      local orgmode = require('orgmode')
      orgmode.setup_ts_grammar()
      orgmode.setup({
        -- org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
        -- org_default_notes_file = '~/Dropbox/org/refile.org',
      })
    end
  },
  { 'https://github.com/NvChad/nvim-colorizer.lua',
    lazy = true,
    opts = {
      buftypes = {
        '!prompt',
        '!popup',
        '!mason',
      },
      user_default_options = {
        tailwind = true
      },
    },
  },
  { 'https://github.com/akinsho/bufferline.nvim',
    event = 'VeryLazy',
    dependencies = {
      'https://github.com/nvim-tree/nvim-web-devicons',
    },
    opts = {
      options = {
        diagnostics = 'nvim_lsp',
        always_show_bufferline = false,
        hover = {
          enabled = true
        },
      },
    },
  },
  -- { 'https://github.com/nvim-tree/nvim-tree.lua',                              -- file tree browser `-`
  --   dependencies = 'https://github.com/nvim-tree/nvim-web-devicons',
  --   opts = {
  --     -- sort_by = 'case_insensitive',
  --     disable_netrw = true,
  --     hijack_cursor = true,
  --     hijack_netrw = true,
  --     hijack_directories = {
  --       enable = true,
  --       auto_open = true,
  --     },
  --     update_focused_file = {
  --       enable = true,
  --       update_root = true,
  --       ignore_list = {},
  --     },
  --     actions = {
  --       open_file = {
  --         quit_on_open = true
  --       },
  --     },
  --     view = {
  --       adaptive_size = true,
  --       side = 'right',
  --     },
  --     renderer = {
  --       group_empty = true,
  --     },
  --     filters = {
  --       dotfiles = false,
  --     },
  --     git = {
  --       enable = true,
  --       ignore = true,
  --     },
  --   },
  --   keys = {
  --     { '-', function() require('nvim-tree.api').tree.toggle({ find_file = true, focus = true, current_window = false }) end, desc = 'Show file in filetree', mode = 'n', silent = true },
  --   },
  -- },
  -- { 'https://github.com/lukas-reineke/indent-blankline.nvim',
  --   event = { 'BufReadPost', 'BufNewFile' },
  --   opts = {
  --     char_list = { '|', '¦', '┆', '┊' },
  --     filetype_exclude = { 'help', 'alpha', 'neo-tree', 'Trouble', 'lazy' },
  --     show_current_context = true,
  --     show_current_context_start = true,
  --     use_treesitter_scope = true,
  --     space_char_highlight_list = { 'Comment' },
  --   },
  -- },
  -- { 'https://github.com/barrett-ruth/import-cost.nvim',
  --     build = 'sh install.sh yarn',
  --     ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  --     opts = {
  --       highlight = 'Comment',
  --       format = {
  --         virtual_text = '%s (gz: %s)',
  --       },
  --     },
  -- },
})

vim.opt.autoread = true
vim.opt.backspace = 'indent,eol,start'                                         -- backspace over everything
vim.opt.colorcolumn = { 80 }                                                   -- highlight 80th column
vim.opt.confirm = true                                                         -- y/n save prompt on quit
vim.opt.equalalways = true
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'                                -- fold by expressions
vim.opt.foldlevelstart = 999                                                   -- open all folds by default
vim.opt.foldmethod = 'expr'
vim.opt.hidden = true                                                          -- switch buffers without saving
vim.opt.hlsearch = true
vim.opt.incsearch = true                                                       -- visual searching
vim.opt.linebreak = true                                                       -- break at word boundaries when wrap enabled
vim.opt.list = true
vim.opt.listchars = { tab = '| ', trail = '★' }                                -- visible tab chars and trailing spaces
vim.opt.listchars:append({ extends = '»', precedes = '«' })                    -- custom line wrap chars
-- vim.opt.listchars:append({ eol = '¬', space = '🞄' })                        -- visible space and eol chars (very noisy)
vim.opt.modeline = true
vim.opt.mouse = 'nv'                                                           -- mouse on for normal,visual mode (but not insert while typing)
vim.opt.number = true                    -- toggle with yon                    -- show current line number (0 with rnu)
vim.opt.relativenumber = true            -- toggle with yor                    -- line numbers relative to current position
vim.opt.showcmd = true                                                         -- visual operator pending
vim.opt.showmode = false                                                       -- hide mode indicator from command (already shown in statusline)
vim.opt.showtabline = 2                                                        -- always show tabline
vim.opt.laststatus = 3                                                         -- always show statusline
vim.opt.signcolumn = 'yes'                                                     -- always keep the sign column open
vim.opt.smarttab = true
vim.opt.splitright = false                                                     -- split defaults
vim.opt.timeoutlen = 100                                                       -- see help
vim.opt.ttimeoutlen = 100                                                      -- see help
vim.opt.backupdir = vim.fn.stdpath('config') .. '/backups//'                   -- vim backups in vim dir
vim.opt.undodir = vim.fn.stdpath('config') .. '/undo//'                        -- undofiles in vim dir
vim.opt.directory = vim.fn.stdpath('config') .. '/swaps//'                     -- swap files in vim dir
vim.opt.undofile = true                                                        -- enable persistent undo files
vim.opt.updatetime = 100                                                       -- cursorhold time and writing swap file debounce time in ms, 
vim.opt.wrap = false                     -- toggle with yow                    -- disable linewrap
-- vim.opt.termguicolors = true
--                    ╒══ Disable hlsearch while loading viminfo
--                    │ ╒══ Remember marks for last 500 files
--                    │ │    ╒══ Remember last 1000 commands
--                    │ │    │     ╒══ Remember last 1000 search patterns
--                    │ │    │     │     ╒══ Remember up to 1MB in each register
--                    │ │    │     │     │     ╒═══ Remember up to 10000 lines in each register
--                    │ │    │     │     │     │
--                    │ │    │     │     │     │
vim.cmd [[set viminfo=h,'500,:1000,/1000,s1000,<10000]]

vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })

-- make Y behave like C and D
vim.keymap.set('', 'Y', 'y$')

-- swap ' and `
vim.keymap.set('', "'", '`')
vim.keymap.set('', '`', "'")

-- an attempt at exclusive folds
vim.keymap.set('n', 'zj', 'zjzMzvzz', { desc = 'Jump to the fold below', silent = true })
vim.keymap.set('n', 'zk', 'zkzMzvzz', { desc = 'Jump to the fold above', silent = true })
vim.keymap.set('n', 'za', 'zazMzvzz', { desc = 'Toggle fold under cursor', silent = true })

-- easy tab size changing
vim.keymap.set('n', '<Leader>t2', '<Cmd>setl ts=2 sw=2<CR>', { desc = 'Set tabsize to 2', silent = true })
vim.keymap.set('n', '<Leader>t4', '<Cmd>setl ts=4 sw=4<CR>', { desc = 'Set tabsize to 4', silent = true })
vim.keymap.set('n', '<Leader>t8', '<Cmd>setl ts=8 sw=8<CR>', { desc = 'Set tabsize to 8', silent = true })

-- unimpaired-like expandtab toggle
vim.keymap.set('n', 'yoe', '<Cmd>set expandtab!<CR>', { desc = 'Toggle expandtab', silent = true })

vim.keymap.set('n', '<Leader>ec', ':e <C-r>=stdpath("config")<CR>/init.lua<CR>', { desc = 'edit config file', silent = true })

-- quicker :s mappings
-- see also :h c_CTRL-R_CTRL-W
vim.keymap.set('n', '<Leader>s', '<esc>:s///gc<left><left><left><left>', { desc = ':subsitute on current line', silent = true })
vim.keymap.set('n', '<Leader>S', '<esc>:%s///gc<left><left><left><left>', { desc = ':subsitute on all lines', silent = true })
vim.keymap.set('x', '<Leader>s', ':s///gc<left><left>', { desc = ':subsitute on selection', silent = true })

-- insert timestamp with ctrl-t
vim.keymap.set({ 'c', 'i' }, '<C-t>', '<C-r>=strftime("%FT%TZ")<Left><Left>', { desc = 'insert timestamp', silent = true })

vim.keymap.set('n', '<Leader>cl', "execute 'norm! yiwoconsole.log({})' | norm! hhp", { desc = 'console.log current word', silent = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({
      -- on_visual = false,
      timeout = 750,
    })
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

-- vim.api.nvim_create_autocmd('BufReadPost', {
--   callback = function()
--     local mark = vim.api.nvim_buf_get_mark(0, '"')
--     local lcount = vim.api.nvim_buf_line_count(0)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "LspReferenceText", { ctermbg = 'black' })
    vim.api.nvim_set_hl(0, "Whitespace", { ctermfg = 0 })
    vim.api.nvim_set_hl(0, "NonText", { ctermfg = 0 })
    vim.api.nvim_set_hl(0, "SpecialKey", { ctermfg = 0 })
    vim.api.nvim_set_hl(0, "WinSeparator", { ctermbg = 'none', ctermfg = 'black' })
    vim.api.nvim_set_hl(0, "DiffChange", { ctermbg = 'none', ctermfg = 'yellow' })
    vim.api.nvim_set_hl(0, "DiffAdd", { ctermbg = 'none', ctermfg = 'green' })
    vim.api.nvim_set_hl(0, "DiffDelete", { ctermbg = 'none', ctermfg = 'red' })
    vim.api.nvim_set_hl(0, "Sneak", { ctermfg = 'black', ctermbg = 'white' })
    vim.api.nvim_set_hl(0, "WinBar", { ctermbg = 'black' })
  end,
  group = vim.api.nvim_create_augroup('colorscheme', { clear = true }),
})

vim.cmd [[
" expand %% in the command prompt to the current dir
cabbrev %% <C-r>=fnameescape(expand('%:h'))<CR>

" common typing mistakes
iabbrev functino function
iabbrev seperate separate
iabbrev actino action
iabbrev improt import
iabbrev frmo from
iabbrev teh the

" common command typos
command! -bang W w<bang>
command! -bang Q q<bang>
command! -bang Qa qa<bang>
command! -bang QA qa<bang>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Wqa wqa<bang>
command! -bang WQa wqa<bang>
command! -bang WQA wqa<bang>

" autocmds
augroup Vim
" always wrap autocmds in an augroup
" reset the augroup so autocmds don't stack on reload
autocmd!

"" enable treesitter by default
" autocmd BufReadPre *
" \ TSEnable highlight

" reload init.lua on save
autocmd BufWritePost $MYVIMRC
\ execute 'luafile %'

" restore last known position in file
autocmd BufReadPost *
\ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line('$') |
\   execute 'normal! g`"zvzz' |
\ endif

" start git commits in insert mode with spelling and textwidth
autocmd FileType gitcommit
\ setlocal spell textwidth=72 |
\ startinsert

" use q to close non-files (help, quickfix, etc)
autocmd BufEnter *
\ if &buftype != '' |
\   nnoremap <silent><buffer> q :<C-u>bw<CR> |
\ endif

" open :help to the right at 80 columns
autocmd FileType help
\ wincmd L |
\ vert resize 81

" expand help when focused
autocmd BufEnter *
\ if &filetype ==? 'help' |
\   execute 'normal 0' |
\   vert resize 81 |
\ endif

" make help small when unfocus
autocmd BufLeave *
\ if &filetype ==? 'help' |
\   vert resize 10 |
\ endif

" make help small when vim resized
autocmd VimResized help
\ vert resize 10

autocmd TermOpen *
\ setlocal nonu nornu signcolumn=no

augroup END

if exists('g:neovide') || exists('g:goneovim')
 set guifont=FiraCode\ Nerd\ Font:h9
 let g:neovide_floating_blur_amount_x = 2.0
 let g:neovide_floating_blur_amount_y = 2.0
 let g:neovide_cursor_animation_length = 0
 set termguicolors
 colorscheme nord
"else
"  colorscheme noctu
endif
]]
