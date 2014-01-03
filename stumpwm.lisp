(in-package :stumpwm)

(set-contrib-dir "/home/dan/build/stumpwm/contrib")
;; (load-module "window-tags")
;; (load-module "frame-tags")

(set-prefix-key (kbd "s-z"))

(set-font "-lucy-tewi-medium-r-normal--11-90-75-75-p-58-iso10646-1")

(setf *mouse-focus-policy* :sloppy)

(resize-head 0 0 14 1366 755)

(setf
      *normal-border-width*       1
      *maxsize-border-width*      1
      *transient-border-width*    1
      *float-window-border*       1
      *float-window-title-height* 1
)
(set-msg-border-width 3)
(setf
      *window-border-style*    :thin
      *message-window-gravity* :top-right
      *input-window-gravity*   :top-right
)
(set-normal-gravity :top) ; top for terminals
(set-maxsize-gravity :center) ; center for floating X apps
(set-transient-gravity :center) ; center for save-as/open popups

(define-key *top-map* (kbd "XF86AudioRaiseVolume") "exec amixer set Master,0 5%+")
(define-key *top-map* (kbd "XF86AudioLowerVolume") "exec amixer set Master,0 5%-")
(define-key *top-map* (kbd "XF86AudioMute") "exec amixer set Master toggle")

;; vim: set ft=lisp
