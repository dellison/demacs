(use-package helm
  :ensure helm
  :init
  (progn
    (setq helm-command-prefix-key "C-c h"))
  :config
  (progn
    (require 'helm-config)
    (require 'helm-eshell)
    (require 'helm-files)
    (require 'helm-grep)
    (require 'helm)
    (global-set-key (kbd "M-x") 'helm-M-x)
    (global-set-key (kbd "C-x C-f") 'helm-find-files)
    (global-set-key (kbd "C-x b") 'helm-mini)
    (global-set-key (kbd "C-c ff") 'helm-projectile)
    (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
    (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
    (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
    (define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
    (define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
    (define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)
    (setq helm-command-prefix-key (kbd "C-c h")
	  helm-buffers-fuzzy-matching t
	  helm-M-x-fuzzy-match t
	  helm-semantic-fuzzy-match t
	  helm-imenu-fuzzy-match t
	  helm-locate-fuzzy-match t
	  helm-apropos-fuzzy-match t
	  helm-lisp-fuzzy-completion t
	  helm-recentf-fuzzy-match t
	  helm-google-suggest-use-curl-p t
	  helm-candidate-number-limit 100
	  ido-use-virtual-buffers t
	  helm-boring-file-regexp-list '("\\.git$"
					 "\\.hg$"
					 "\\.svn$"
					 "\\.CVS$"
					 "\\._darcs$"
					 "\\.la$"
					 "\\.o$"
					 "\\.i$"
					 "\\.class$"
					 "\\.pyc$"))
    (add-hook 'helm-goto-line-before-hook 'helm-save-current-pos-to-mark-ring)
    (helm-mode 1)))

(provide 'setup-helm)
