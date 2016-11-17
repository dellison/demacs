;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; my setup for Evil Mode, the VIM emulation layer for emacs.               ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package evil
  :ensure evil
  :config
  (evil-mode 1)
  (setq evil-move-cursor-back t
	evil-cross-lines t
	evil-insert-state-cursor '("#FFFFFF"  box) ;; white
	evil-emacs-state-cursor  '("#FFFFFF"  box)
	evil-motion-state-cursor '("#D0BF8F"  box) ;; same as "zenburn-yellow-2"
	evil-normal-state-cursor '("#D0BF8F"  box)
	evil-visual-state-cursor '("#D0BF8F"  box)))

(use-package evil-matchit
  :ensure evil-matchit
  :config
  (global-evil-matchit-mode 1)
  (evil-matchit-mode 1))

(use-package evil-paredit
  :ensure evil-paredit)

(use-package evil-nerd-commenter
  :ensure evil-nerd-commenter
  :config
  (global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines))

(use-package evil-surround
  :ensure evil-surround)
(global-evil-surround-mode 1)

(use-package evil-leader
  :ensure evil-leader
  :config
  (evil-leader/set-leader "SPC")
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
    "de"  'de/visit-demacs
    "di"  'ediff-current-file
    "e"   'eshell
    "f"   'find-name-dired
    "g"   'helm-do-grep
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
    "w"   'de/eww-dwim
    "x"   'execute-extended-command)
  (global-evil-leader-mode 1)
  (require 'dired)
  ;; make evil leader okay in dired
  (define-key dired-mode-map (kbd "SPC") nil))

(defun de/comint-shell-command (command)
  "executes a shell command (in comint mode) in the current directory"
  (interactive "sRun: ")
  (let* ((tokens (split-string command))
	 (cmd (car tokens))
	 (args (mapconcat 'identity (cdr tokens) " ")))
    ;; (message(format "running command %s with args %s" cmd args))
    (switch-to-buffer (make-comint cmd cmd nil args))))

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
  (define-key evil-insert-state-map (kbd "C-z") 'de/dont-suspend-frame))

(define-key evil-motion-state-map (kbd "RET") nil)

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

;; back to normal state after being idle for a few seconds
(defun de/evil-back-to-normal-state ()
  "back to normal state if you're in insert/emacs state"
  (interactive)
  (when (or (evil-emacs-state-p) (evil-insert-state-p))
    (evil-normal-state)
    (message "Back to (evil) normal.")))

;; (run-with-idle-timer 5.0 nil 'de/evil-back-to-normal-state)

;;; Start the following modes in the Emacs state:
(setq initial-state-emacs-modes '(cider-docview-mode
				  cider-repl-mode
				  cider-test-report-mode
				  cider-stacktrace-mode
				  comint-mode
				  compilation-mode
				  debugger-mode
				  diff-mode
				  dired-mode
				  doc-view-mode
				  docker-images-mode
				  dockerfile-mode
				  eshell-mode
				  ess-help-mode
				  git-commit-mode
				  haskell-interactive-mode
				  help-mode
				  ielm-mode
				  inferior-ess-mode
				  inferior-haskell-mode
				  inferior-octave-mode
				  inf-ruby-mode
				  Info-mode
				  inferiorer-python-mode
				  magit-mode
				  message-mode
				  prolog
				  shell-mode
				  special-mode
				  sql-interactive-mode
				  term-mode))
(mapc (lambda (m)
	(evil-set-initial-state m 'emacs))
      initial-state-emacs-modes)

;; "quit" with C-g also sends you back to normal mode
(defadvice keyboard-quit (before evil activate)
  (when (and (fboundp 'evil-normal-state) (not (memq major-mode initial-state-emacs-modes)))
    (evil-normal-state)))


(provide 'setup-evil)
