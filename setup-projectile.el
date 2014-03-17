(install-if-needed 'projectile)

(require 'projectile)
 (projectile-mode 1)

(global-set-key (kbd "C-c ff") 'projectile-find-file)

(provide 'setup-projectile)
