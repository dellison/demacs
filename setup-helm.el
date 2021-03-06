(use-package helm
  :ensure helm
  :init
  (setq helm-command-prefix-key "C-c h")

  :config
  (require 'helm-config)
  (require 'helm-eshell)
  (require 'helm-files)
  (require 'helm-grep)
  (require 'helm)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "C-c ff") 'helm-projectile)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
  (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
  (define-key helm-map (kbd "C-w") 'backward-kill-word)
  (define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
  (define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
  (define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)
  (setq helm-command-prefix-key (kbd "C-c h")

	helm-split-window-in-side-p t
	helm-split-window-default-side 'below
	;; helm-always-two-windows nil
	;; helm-autoresize-mode t
	
	helm-buffers-fuzzy-matching t
	helm-M-x-fuzzy-match t
	helm-scroll-amount nil
	helm-semantic-fuzzy-match t
	helm-imenu-fuzzy-match t
	helm-locate-fuzzy-match t
	helm-apropos-fuzzy-match t
	helm-lisp-fuzzy-completion t
	helm-recentf-fuzzy-match t
	helm-google-suggest-use-curl-p t
	helm-candidate-number-limit 50
	helm-autoresize-min-height 40
	helm-autoresize-max-height 40	  
	ido-use-virtual-buffers t
	helm-boring-file-regexp-list '("\\.git$"
				       "\\.hg$"
				       "\\.svn$"
				       "\\.CVS$"
				       "\\._darcs$"
				       "\\.la$"
				       "\\.o$"
				       "\\.i$"
				       "\\.so$"
				       "\\.class$"
				       "\\.elc$"
				       "\\.pyc$"))
  (add-hook 'helm-goto-line-before-hook 'helm-save-current-pos-to-mark-ring)
  (helm-mode 1))

;; use shackle package to better manage helm windows
(use-package shackle
  :ensure shackle
  :config
  (setq shackle-rules
	'( ;;; Helm windows should always be on the bottom
	     ;;; (without clobbering any existing windows)
	  ("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.28)))
  (shackle-mode 1))

(use-package helm-pydoc
  :ensure helm-pydoc
  :config
  (bind-key "p" 'helm-pydoc 'helm-command-prefix))

(use-package helm-unicode
  :ensure helm-unicode
  :config
  (bind-key "u" 'helm-unicode 'helm-command-prefix))

(use-package helm-swoop
  :ensure helm-swoop
  :config
  ;; keybindings
  (global-set-key (kbd "M-i") 'helm-swoop)
  (global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
  (global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
  (global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)
  ;; from isearch
  (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
  (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop))

(provide 'setup-helm)
