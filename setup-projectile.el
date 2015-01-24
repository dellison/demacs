(install-if-needed 'projectile)

(require 'projectile)
 (projectile-mode 1)

(if (fboundp 'helm)
    (global-set-key (kbd "C-c ff") 'helm-projectile)
  (global-set-key (kbd "C-c ff") 'projectile-find-file))

(provide 'setup-projectile)
