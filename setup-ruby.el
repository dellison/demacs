(use-package inf-ruby
  :ensure inf-ruby
  :init (progn
	  (defalias 'irb 'run-ruby)))

(use-package rvm
  :ensure rvm
  :init (progn))

(use-package projectile-rails
  :ensure projectile-rails
  :init (progn))

(use-package robe
  :ensure robe
  :init (progn))

(use-package web-mode
  :ensure web-mode
  :init (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode)))

(defun de/ruby-mode-hook ()
  "setup for ruby files"
  (setq sp-show-pair-from-inside 1)
  (smartparens-mode 1)
  (show-smartparens-mode 1)
  (robe-mode 1)
  (projectile-on)
  (local-set-key (kbd "C-c r a") 'rvm-activate-corresponding-ruby)
  (local-set-key (kbd "C-c r r") 'inf-ruby))

(add-hook 'ruby-mode-hook 'de/ruby-mode-hook nil t)

(defun de/irb-mode-hook ()
  "setup stuff for interactive ruby"
  (setq sp-show-pair-from-inside 1)
  (smartparens-mode 1)
  (show-smartparens-mode 1)
  (local-set-key (kbd "C-c r a") 'rvm-activate-corresponding-ruby)
  (local-set-key (kbd "C-c r r") 'inf-ruby))

(add-hook 'inf-ruby-mode-hook 'de/irb-mode-hook nil t)

(provide 'setup-ruby)
