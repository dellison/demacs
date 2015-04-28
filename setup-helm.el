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
    (global-set-key (kbd "M-y") 'helm-show-kill-ring)
    (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
    (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
    (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
    (define-key helm-map (kbd "C-w") 'backward-kill-word)
    (define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
    (define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
    (define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)
    ;(define-key helm-map (k))
    ;; (helm-autoresize-mode t)
    (setq helm-command-prefix-key (kbd "C-c h")

	  ;; helm-split-window-in-side-p nil
	  ;; helm-split-window-default-side 'below
	  ;; helm-always-two-windows nil
	  ;; helm-autoresize-mode t
	  
	  helm-buffers-fuzzy-matching t
	  helm-M-x-fuzzy-match t
	  helm-scroll-amount 0
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
					 "\\.class$"
					 "\\.pyc$"))
    (add-hook 'helm-goto-line-before-hook 'helm-save-current-pos-to-mark-ring)
    (helm-mode 1)))

;; use shackle package to better manage helm windows
(use-package shackle
  :ensure shackle
  :config
  (progn
    (setq shackle-rules
	  '( ;;; Helm windows should always be on the bottom
	     ;;; (without clobbering any existing windows) at 40% height.
	    ("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.4)))
    (shackle-mode 1)))

(provide 'setup-helm)
