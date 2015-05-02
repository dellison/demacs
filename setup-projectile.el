(use-package projectile
  :ensure projectile
  :config
  (progn
    (projectile-mode 1)
    (global-set-key (kbd "C-c ff") 'helm-projectile)))

(use-package helm-projectile
  :ensure helm-projectile)

(provide 'setup-projectile)
