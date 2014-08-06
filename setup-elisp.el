;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Setup for editing emacs lisp
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(mapc 'install-if-needed '(elisp-slime-nav
			   ;; litable
			   paredit))

(require 'elisp-slime-nav)
;; (require 'litable) ;; changed my mind about this one, i think
(require 'paredit)
(require 'setup-lisps)

(defvar de/scratch-yeah ";     ___        ___    _________   _____   __       __    __
;     \\  \\      /  /   /  ______/  /    |  |  |     |  |  |  |
;      \\  \\    /  /   /  /        /     |  |  |     |  |  |  |
;       \\  \\  /  /   /  /        /      |  |  |     |  |  |  |
;        \\  \\/  /   /  /        /       |  |  |     |  |  |  |
;         \\    /   /  /____    /        |  |  |_____|  |  |  |
;          /  /   /  _____/   /         |  |  _______  |  |  |
;         /  /   /  /        /  _____   |  |  |     |  |  |  |
;        /  /   /  /        /  /     |  |  |  |     |  |  |  |
;       /  /   /  /        /  /      |  |  |  |     |  |  |__|
;    __/  /   /  /______  /  /       |  |  |  |     |  |   __
;   |____/   /_________/ /__/        |__|  |__|     |__|  |__|
;   

" "YEAH")
(setq initial-scratch-message de/scratch-yeah)

(defun de/elisp-mode-hook ()
  "hook for emacs lisp mode"
  (paredit-mode 1) ;; use paredit
  (elisp-slime-nav-mode 1)
  (eldoc-mode 1)
  ;; (auto-complete-mode -1)
  (litable-mode -1) ; don't use litable mode, actually...
  (paredit-mode 1)
  (smartparens-mode -1) ;; use paredit for elisp instead

  ;; couldn't get this to work yet :(
  ;; I don't want hippie-expand to use try-expand-line because
  ;; it screws up paredit & the AST
  ;; (set (make-local-variable hippie-expand-try-functions-list)
  ;;      (delete 'try-expand-line 'hippie-expand-try-functions-list
  ;; 	))
  ;; (setq hippie-expand-try-functions-list (delete 'try-expand-line 'hippie-expand-try-functions-list))

  ;; use shift-space to insert -
  (define-key evil-insert-state-local-map (kbd "S-SPC") (lambda () (interactive) (insert "-")))
  (define-key evil-normal-state-local-map (kbd "M-.") 'elisp-slime-nav-find-elisp-thing-at-point)
  (define-key evil-insert-state-local-map (kbd "TAB") 'helm-lisp-completion-at-point)
  (turn-on-elisp-slime-nav-mode)
  (diminish 'undo-tree-mode)
  (diminish 'yas-minor-mode))

(add-hook 'emacs-lisp-mode-hook 'de/elisp-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'de/lisps-mode-hook)

(add-hook 'ielm-mode-hook 'de/elisp-mode-hook)
(add-hook 'ielm-mode-hook 'de/lisps-mode-hook)

(add-hook 'lisp-mode-hook 'de-elisp-mode-hook)
(add-hook 'lisp-mode-hook 'de/lisps-mode-hook)

(add-hook 'minibuffer-setup-hook
	  (defun de/minibuffer-setup-hook ()
	    (local-set-key (kbd "S-SPC") (lambda () (interactive) (insert "-")))
	    ;; Setup paredit for elisp
	    (when (eq this-command 'eval-expression)
	      (paredit-mode 1)
	      (local-set-key (kbd "S-SPC") (lambda () (interactive) (insert "-")))
	      (paredit-open-round))))

(add-hook 'ielm-mode-hook
	  (defun de/ielm-mode-hook ()
	    "Hook for setting up IELM (interactive emacs lisp mode)"
	    (litable-mode -1)
	    (define-key evil-insert-state-local-map (kbd "DEL") 'paredit-backward-delete)))

(require 'setup-lisps)
(add-hook 'emacs-lisp-mode-hook 'de/lisps-mode-hook)
(add-hook 'lisps-mode-hook 'de/lisps-mode-hook)

(provide 'setup-elisp)
