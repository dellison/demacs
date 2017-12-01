(use-package projectile
  :ensure projectile

  :config
  (projectile-mode 1))

(use-package counsel-projectile
  :ensure t

  :config
  (global-set-key (kbd "C-c ff") #'counsel-projectile-find-file))

(provide 'setup-projectile)
