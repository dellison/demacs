(mapc 'install-if-needed '(evil
			   evil-matchit
			   evil-nerd-commenter
			   evil-paredit
			   evil-leader))

(setq evil-move-cursor-back t)
(setq evil-cross-lines t)

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

(evil-leader/set-key
  "x" 'execute-extended-command
  "g" 'magit-status
  "e" 'eshell
  "k" (lambda () (interactive) (kill-buffer nil))
  "de" 'de/open-emacs-configuration-file
  "m" 'woman
   )

;(evilnc-default-hotkeys)

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

(setcdr evil-insert-state-map nil) ;; just use normal emacs for insert state
(define-key evil-insert-state-map [escape] 'evil-normal-state)

(provide 'setup-evil)
