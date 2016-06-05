;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Setup for editing emacs lisp
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package elisp-slime-nav
  :ensure elisp-slime-nav)

(use-package litable
  :ensure litable
  :config
  (add-hook 'lisp-interaction-mode-1 'litable-mode))

(require 'elisp-slime-nav)
;; (require 'litable) ;; changed my mind about this one, i think
(require 'paredit)
(require 'setup-lisps)

(defvar de/scratch-yeah ";;    ___        ___    _________   _____   __       __    __
;;    \\  \\      /  /   /  ______/  /    |  |  |     |  |  |  |
;;     \\  \\    /  /   /  /        /     |  |  |     |  |  |  |
;;      \\  \\  /  /   /  /        /      |  |  |     |  |  |  |
;;       \\  \\/  /   /  /        /       |  |  |     |  |  |  |
;;        \\    /   /  /____    /        |  |  |_____|  |  |  |
;;         /  /   /  _____/   /         |  |  _______  |  |  |
;;        /  /   /  /        /  _____   |  |  |     |  |  |  |
;;       /  /   /  /        /  /     |  |  |  |     |  |  |  |
;;      /  /   /  /        /  /      |  |  |  |     |  |  |__|
;;   __/  /   /  /______  /  /       |  |  |  |     |  |   __
;;  |____/   /_________/ /__/        |__|  |__|     |__|  |__|
;;  

" "YEAH")

(defun de/elisp-scratch-buffer-message ()
  "create the message at the top of an elisp scratch buffer"
  (format ";;; elisp scratch buffer, opened %s
;;; in %s

"
	  (format-time-string "%A, %B %d, %Y at %H:%M %p")
	  default-directory))

(setq initial-scratch-message (de/elisp-scratch-buffer-message))

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
  (insert (de/elisp-scratch-buffer-message)))

(defun de/elisp-mode-hook ()
  "hook for emacs lisp mode"
  (paredit-mode 1) ;; use paredit
  (elisp-slime-nav-mode 1)
  (eldoc-mode 1)
  (paredit-mode 1)
  (define-key evil-insert-state-local-map (kbd "S-SPC")
    (lambda () (interactive) (insert "-")))
  (define-key evil-emacs-state-local-map (kbd "S-SPC")
    (lambda () (interactive) (insert "-")))
  (define-key evil-normal-state-local-map (kbd "M-.") 'elisp-slime-nav-find-elisp-thing-at-point)
  (turn-on-elisp-slime-nav-mode)
  (local-set-key (kbd "C-c C-j") 'imenu)
  (if (fboundp 'helm)
      (local-set-key (kbd "C-M-i") 'helm-lisp-completion-at-point))
  (local-set-key (kbd "C-RET") 'de/evil-paredit-open-below))


(add-hook 'emacs-lisp-mode-hook 'de/elisp-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'de/lisps-mode-hook)

;; (add-hook 'ielm-mode-hook 'de/elisp-mode-hook)
;; (add-hook 'ielm-mode-hook 'de/lisps-mode-hook)

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
