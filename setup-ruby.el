;; (setq de-ruby-packages '(inf-ruby))

;; (mapc 'install-if-needed de-ruby-packages)

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
  (smartparens-mode 1)
  (robe-mode 1)
  (projectile-on)
  (local-set-key (kbd "C-c r a") 'rvm-activate-corresponding-ruby)
  (local-set-key (kbd "C-c r r") 'inf-ruby)
  )

(add-hook 'ruby-mode-hook 'de/ruby-mode-hook)

(provide 'setup-ruby)
