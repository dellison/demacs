(use-package inf-ruby
  :ensure inf-ruby
  :config
  (defalias 'irb 'run-ruby))

(defun de/ruby-mode-hook ()
  "setup for ruby files"
  ;; (smartparens-mode 1)
  ;; (setq sp-show-pair-from-inside 1)
  ;; (show-smartparens-mode 1)
  (projectile-on)
  (local-set-key (kbd "C-c r r") 'inf-ruby))

(add-hook 'ruby-mode-hook 'de/ruby-mode-hook nil t)

(defun de/irb-mode-hook ()
  "setup stuff for interactive ruby"
  (setq sp-show-pair-from-inside 1)
  ;; (smartparens-mode 1)
  ;; (show-smartparens-mode 1)
  ;; (local-set-key (kbd "C-c r a") 'rvm-activate-corresponding-ruby)
  (local-set-key (kbd "C-c r r") 'inf-ruby))

(add-hook 'inf-ruby-mode-hook 'de/irb-mode-hook)

(provide 'setup-ruby)
