(install-if-needed 'magit)

(require 'magit)

(global-set-key (kbd "\C-c gs") 'magit-status)

(provide 'setup-magit)

(when (eq system-type 'darwin)
  ; this fixes the problem where commits spawn a new emacsclient
  (setq magit-emacsclient-executable "/usr/local/Cellar/emacs/24.3/bin/emacsclient"))
