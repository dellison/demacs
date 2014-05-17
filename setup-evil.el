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
      evil-insert-state-cursor '(bar . 3)
      evil-emacs-state-cursor '(bar . 3))


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
  "=="  'ediff-current-file
  "v="  'vc-ediff 
  "SPC" 'smex
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

;; keep some emacs bindings
(define-key evil-normal-state-map "\C-e" 'evil-end-of-line)
(define-key evil-insert-state-map "\C-e" 'end-of-line)
(define-key evil-visual-state-map "\C-e" 'evil-end-of-line)
(define-key evil-motion-state-map "\C-e" 'evil-end-of-line)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Below are hooks to change the color of the mode line depending
; on the Evil state (i.e. Vim mode). Colors are:
; Normal Mode:
; fg: #DCDCCC zenburn-fg
; bg: #5D3FA6 zenburn-bg-1
; Insert Mode:
; fg: #DC8CC3 zenburn-magenta
; bg: #4D3FA6 zenburn-blue-5
; Visual Mode:
; fg: #DCA3A3 zenburn-red+1
; bg: #8C5353 zenburn-red-4
; Emacs-Mode:
; fg: #BFEBBF zenburn-green+4
; bg: #5F7F5F zenburn-green-4

;; (add-hook 'evil-insert-state-entry-hook
;; 	  (defun de/evil-insert-state-entry-hook ()
;; 	    (when (display-graphic-p)
;; 	      (face-remap-add-relative 'mode-line
;; 				       '((:foreground "#4D3FA6" :background "#2B2B2B")
;; 					 mode-line)))))
;; 					;previously '((:foreground "#DC8CC3" :background "#4D3FA6")

;; (add-hook 'evil-normal-state-entry-hook
;; 	  (defun de/evil-normal-state-entry-hook ()
;; 	    (when (display-graphic-p)
;; 	      (face-remap-add-relative 'mode-line
;; 				       '((:foreground "#5F7F5F" :background "#2B2B2B")
;; 					 mode-line)))))	

;; (add-hook 'evil-visual-state-entry-hook
;; 	  (defun de/evil-visual-state-entry-hook ()
;; 	    (when (display-graphic-p)
;; 	      (face-remap-add-relative 'mode-line
;; 				       '((:foreground "#DCA3A3" :background "#8C5353")
;; 					 mode-line)))))
;; (add-hook 'evil-emacs-state-entry-hook
;; 	  (defun de/evil-emacs-state-entry-hook ()
;; 	    (when (display-graphic-p) 
;; 	      (face-remap-add-relative 'mode-line
;; 				       '((:foreground "#BFEBBF" :background "#5F7F5F")
;; 					 mode-line)))))

; (setq evil-insert-state-cursor nil) ; originally (bar . 2)
(setq evil-insert-state-cursor '(bar . 3))
(setq evil-emacs-state-cursor '(bar . 3))

(setcdr evil-insert-state-map nil) ;; just use normal emacs for insert state
(define-key evil-insert-state-map [escape] 'evil-normal-state)

(provide 'setup-evil)
