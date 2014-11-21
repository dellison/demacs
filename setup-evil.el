;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Setup for Evil Mode, the VIM emulation layer for emacs.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package evil
  :ensure evil
  :init
  (progn
    (evil-mode 1)))


(mapc 'install-if-needed '(;;evil
			   evil-matchit
			   ;; evil-nerd-commenter
			   evil-paredit
			   evil-leader))

(setq evil-move-cursor-back t
      evil-cross-lines t
      evil-insert-state-cursor '("#FFFFFF"  box)
      evil-emacs-state-cursor  '("#FFFFFF"  box)
      evil-motion-state-cursor '("#F0DFAF"  box)
      evil-normal-state-cursor '("#F0DFAF"  box)
      evil-visual-state-cursor '("#F0DFAF"  box))

;; (evilnc-default-hotkeys)

(global-evil-matchit-mode 1)
(evil-matchit-mode 1)

;;; make evil leader okay in dired
(require 'dired)
(define-key dired-mode-map (kbd "SPC") nil)

(require 'evil)
;; (require 'evil-nerd-commenter)
(require 'evil-leader)
(require 'evil-paredit)

(evil-leader/set-leader ",")
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

;; (evilnc-default-hotkeys)

;;; don't skip wrapped lines
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

;; keep some emacs bindings
;; (define-key evil-normal-state-map "\C-e" 'evil-end-of-line)
;; (define-key evil-insert-state-map "\C-e" 'end-of-line)
;; (define-key evil-visual-state-map "\C-e" 'evil-end-of-line)
;; (define-key evil-motion-state-map "\C-e" 'evil-end-of-line)

(define-key evil-normal-state-map (kbd "C-w") 'backward-kill-word)

(define-key evil-visual-state-map "\C-n" 'evil-next-line)

(define-key evil-normal-state-map "\C-p" 'evil-previous-line)
(define-key evil-visual-state-map "\C-p" 'evil-previous-line)

(define-key evil-normal-state-map (kbd "C-r") 'isearch-backward-regexp)

(define-key evil-normal-state-map (kbd "C-t") 'transpose-chars)
(define-key evil-normal-state-map (kbd "M-t") 'transpose-words)
(define-key evil-normal-state-map (kbd "s-M-t") 'transpose-sexps)

(when (display-graphic-p)
  (defun de/dont-suspend-frame ()
    (interactive)
    (message "didn't suspend the frame!"))
  (define-key evil-emacs-state-map (kbd "C-z") 'de/dont-suspend-frame)
  (define-key evil-insert-state-map (kbd "C-z") 'de/dont-suspend-frame)
  (message "yeah!"))

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

;;; Start the following modes in the Emacs state:
(let ((initial-state-emacs-modes '(cider-docview-mode
				   cider-repl-mode
				   cider-test-report-mode
				   cider-stacktrace-mode
				   comint-mode
				   debugger-mode
				   diff-mode
				   dired-mode
				   doc-view-mode
				   eshell-mode
				   git-commit-mode
				   haskell-interactive-mode
				   help-mode
				   ielm-mode
				   inferior-ess-mode
				   inf-ruby-mode
				   Info-mode
				   inferiorer-python-mode
				   magit-mode
				   prolog
				   shell-mode
				   sql-interactive-mode
				   term-mode)))
  (mapc (lambda (m)
	  (evil-set-initial-state m 'emacs))
	initial-state-emacs-modes))

(use-package evil-nerd-commenter
  :ensure evil-nerd-commenter
  :config
  (progn
    (require 'evil-nerd-commenter)
    (evilnc-default-hotkeys)))

(provide 'setup-evil)
