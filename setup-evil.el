;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Setup for Evil Mode, the VIM emulation layer for emacs.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(mapc 'install-if-needed '(evil
			   evil-matchit
			   evil-nerd-commenter
			   evil-paredit
			   evil-leader))

(setq evil-move-cursor-back t
      evil-cross-lines t
      evil-insert-state-cursor (defun de/set-insert-state-cursor ()
				 (setq cursor-type '(bar . 4))
				 (set-face-attribute 'cursor nil :background "#FFFFFF")
				 (blink-cursor-mode 10))
      evil-emacs-state-cursor (defun de/set-emacs-state-cursor ()
				(blink-cursor-mode -1)
				(set-face-attribute 'cursor nil :background "#CC99FF")
				(setq 'cursor-type 'box))
      evil-motion-state-cursor (defun de/set-motion-state-cursor ()
				 (setq 'cursor-type 'box)
				 (set-face-attribute 'cursor nil :background "#6666FF")
				 (blink-cursor-mode -1))
      evil-normal-state-cursor (defun de/set-normal-state-cursor ()
				 (setq cursor-type 'box)
				 (set-face-attribute 'cursor nil :background "#FFFFFF")
				 (blink-cursor-mode -1))
      evil-visual-state-cursor (defun de/set-visual-state-cursor ()
				 (setq cursor-type 'box)
				 (set-face-attribute 'cursor nil :background "#3399FF")
				 (blink-cursor-mode -1)))

(evilnc-default-hotkeys)

(global-evil-matchit-mode 1)
(evil-matchit-mode 1)

;;; make evil leader okay in dired
(require 'dired)
(define-key dired-mode-map (kbd "SPC") nil)

(require 'evil)
(require 'evil-nerd-commenter)
(require 'evil-leader)
(require 'evil-paredit)

(evil-leader/set-leader "<SPC>")
;; (evil-leader/set-key-for-mode 'Info-mode (kbd "S-SPC"))

(global-evil-leader-mode)
(evil-leader-mode 1)
(evil-mode 1)

(defun de/comint-shell-command (command)
  "executes a shell command (in comint mode) in the current directory"
  (interactive "sRun: ")
  (let* ((tokens (split-string command))
	 (cmd (car tokens))
	 (args (mapconcat 'identity (cdr tokens) " ")))
    ; (message(format "running command %s with args %s" cmd args))
    (switch-to-buffer (make-comint cmd cmd nil args))))

(defun de/switch-to-scratch-buffer-here ()
  "create an elisp interaction buffer in the current directory (if necessary)
and switch to it."
  (interactive)
  (let ((local-scratch-buffer-name (format "*scratch: %s*" default-directory)))
    (if (get-buffer local-scratch-buffer-name)
	(switch-to-buffer local-scratch-buffer-name)
      (de/initialize-scratch-buffer-here local-scratch-buffer-name))))

(defun de/initialize-scratch-buffer-here (name)
  "create a elisp interaction buffer in the current directory"
  (switch-to-buffer (get-buffer-create name))
  (goto-char (point-min))
  (lisp-interaction-mode)
  (insert (format "; elisp scratch buffer, opened %s\n; in %s\n\n"
		  (format-time-string "%A, %B %d, %Y at %H:%M %p")
		  default-directory
		  )))

;; use spacebar as the leader key
(evil-leader/set-key
  "0"   'delete-window
  "1"   'delete-other-windows
  "3"   'split-window-right
  "\\"  'shell-command
  "=="  'ediff-current-file
  "v="  'vc-ediff 
  "SPC" 'execute-extended-command
  "TAB" 'de/comint-shell-command
  "c"   'calc
  "de"  'de/open-emacs-configuration-file
  "di"  'ediff-current-file
  "e"   'eshell
  "f"   'find-name-dired
  "g"   'magit-status
  "i"   'info
  "k"   (defun de/kill-this-buffer ()
	  (interactive)
	  (let ((prompt
		 (format "Kill %s? %s"
			 (buffer-name)
			 (if (buffer-modified-p)
			     "(buffer is unsaved) "
			   ""))))
	    (if (y-or-n-p prompt)
		(kill-buffer)))
	  (message ""))
  "j"   'ace-jump-char-mode
  "l"   'ibuffer
  "m"   'woman
  "py"  'run-python
  "q"   (defun de/qrr-in-buffer (regexp to-string)
	  "qrr in whole buffer"
	  (interactive "sQRRegexp: \nsReplace with: ")
	  (save-excursion
	    (query-replace-regexp regexp to-string nil (point-min) (point-max))))
  "r"   're-builder
  "s"   'de/switch-to-scratch-buffer-here ; see setup-elisp.el
  "x"   'execute-extended-command
   )

(evilnc-default-hotkeys)

;;; don't skip wrapped lines
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

;; keep some emacs bindings
(define-key evil-normal-state-map "\C-e" 'evil-end-of-line)
(define-key evil-insert-state-map "\C-e" 'end-of-line)
(define-key evil-visual-state-map "\C-e" 'evil-end-of-line)
(define-key evil-motion-state-map "\C-e" 'evil-end-of-line)

(define-key evil-normal-state-map (kbd "C-w") 'backward-kill-word)

; (define-key evil-normal-state-map "\C-f" 'evil-forward-char)
(define-key evil-insert-state-map "\C-f" 'evil-forward-char)
(define-key evil-visual-state-map "\C-f" 'evil-forward-char)

; (define-key evil-normal-state-map "\C-b" 'evil-backward-char)
(define-key evil-insert-state-map "\C-b" 'evil-backward-char)
(define-key evil-visual-state-map "\C-b" 'evil-backward-char)

; (define-key evil-normal-state-map "\C-d" 'delete-char)
(define-key evil-insert-state-map "\C-d" 'delete-char)
(define-key evil-visual-state-map "\C-d" 'delete-char)

; (define-key evil-normal-state-map "\C-n" 'evil-next-line)
(define-key evil-insert-state-map "\C-n" 'evil-next-line)
(define-key evil-visual-state-map "\C-n" 'evil-next-line)

(define-key evil-normal-state-map "\C-p" 'evil-previous-line)
(define-key evil-insert-state-map "\C-p" 'evil-previous-line)
(define-key evil-visual-state-map "\C-p" 'evil-previous-line)

(define-key evil-insert-state-map "\C-k" 'kill-line)

; (define-key evil-normal-state-map "\C-y" 'yank)
(define-key evil-insert-state-map "\C-y" 'yank)
(define-key evil-visual-state-map "\C-y" 'yank)

(define-key evil-normal-state-map (kbd "C-r") 'isearch-backward-regexp)

(define-key evil-insert-state-map (kbd "C-t") 'transpose-chars)
(define-key evil-normal-state-map (kbd "C-t") 'transpose-chars)
(define-key evil-insert-state-map (kbd "M-t") 'transpose-words)
(define-key evil-normal-state-map (kbd "M-t") 'transpose-words)
(define-key evil-insert-state-map (kbd "s-M-t") 'transpose-sexps)
(define-key evil-normal-state-map (kbd "s-M-t") 'transpose-sexps)

(define-key evil-motion-state-map (kbd "RET") nil)

;; now "quit" with C-g also sends you back to normal mode
(defadvice keyboard-quit (before evil activate)
  (when (fboundp 'evil-normal-state)
    (evil-normal-state)))

;; always re-enter Normal State after saving with C-x C-s
(define-key evil-insert-state-map (kbd "C-x C-s")
  (defun de/evil-save-and-enter-normal-state ()
    "Save buffer and go to normal state."
    (interactive)
    (save-buffer)
    (evil-normal-state)))

(setcdr evil-insert-state-map nil) ;; just use normal emacs for insert state
(define-key evil-insert-state-map [escape] 'evil-normal-state)
(when (display-graphic-p)
  (define-key evil-emacs-state-map [escape] 'evil-normal-state))

;;; set modes for initial states
(evil-set-initial-state 'cider-docview-mode       'emacs)
(evil-set-initial-state 'cider-repl-mode          'emacs)
(evil-set-initial-state 'cider-stacktrace-mode    'emacs)
(evil-set-initial-state 'comint-mode              'emacs)
(evil-set-initial-state 'debugger-mode            'emacs)
(evil-set-initial-state 'diff-mode                'emacs)
(evil-set-initial-state 'dired-mode               'emacs)
(evil-set-initial-state 'eshell-mode              'emacs)
(evil-set-initial-state 'git-commit-mode          'emacs)
(evil-set-initial-state 'haskell-interactive-mode 'emacs)
(evil-set-initial-state 'ielm-mode                'emacs)
(evil-set-initial-state 'inferior-ess-mode        'emacs)
(evil-set-initial-state 'inf-ruby-mode            'emacs)
(evil-set-initial-state 'inferiorer-python-mode   'emacs)
(evil-set-initial-state 'magit-mode               'emacs)
(evil-set-initial-state 'shell-mode               'emacs)
(evil-set-initial-state 'sql-interactive-mode     'emacs)
(evil-set-initial-state 'term-mode                'emacs)

(provide 'setup-evil)
