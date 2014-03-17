(install-if-needed 'smex)
(require 'smex)
(smex-initialize)

(when (fboundp 'smex)
  (global-set-key (kbd "M-x") 'smex))

(provide 'setup-smex)
