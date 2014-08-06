(if (and (fboundp 'menu-bar-mode) (not (eq system-type 'darwin))) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(setq inhibit-startup-message t)
(global-subword-mode 1)

(setq echo-keystrokes 0.1)
(set-default 'indicate-empty-lines t)

(setq enable-recursive-minibuffers t)
(show-paren-mode -1)

(when (display-graphic-p)
  (global-hl-line-mode 1))

(setq visible-bell t)
(blink-cursor-mode -1)

(setq scroll-conservatively 1
      scroll-margin 0)

(setq dired-listing-switches "-hal") 

;; (setq auto-save-default nil)

(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; mode line stuff
(mapc 'install-if-needed '(diminish))
(display-time-mode 1)
(column-number-mode t)

(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

;; ediff stuff
(setq ediff-split-window-function 'split-window-horizontally)

;; it's the future now, so you can use a lot of memory
(setq gc-cons-threshold 20000000)

;;; enable disabled commands
(put 'downcase-region  'disabled nil)   ; Let downcasing work
(put 'erase-buffer     'disabled nil)
(put 'eval-expression  'disabled nil)   ; Let ESC-ESC work
(put 'narrow-to-page   'disabled nil)   ; Let narrowing work
(put 'narrow-to-region 'disabled nil)   ; Let narrowing work
(put 'set-goal-column  'disabled nil)
(put 'upcase-region    'disabled nil)   ; Let upcasing work

;;; let's just enable everything else too...
(mapatoms (lambda (s) (when (get s 'disabled) (put s 'disabled nil))))

(provide 'setup-preferences)
