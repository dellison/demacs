(use-package slime
  :ensure t
  :config
  (when (equal system-type 'darwin)
    (setenv "LANG" "en_US.UTF-8")
    (setq inferior-lisp-program "/usr/local/bin/sbcl")
    (setq slime-lisp-implementations '((sbcl ("/usr/local/bin/sbcl") :coding-system utf-8-unix)))
    (require 'slime)
    (slime-setup)))

(add-hook 'slime-mode-hook 'de/lisps-mode-hook)
(add-hook 'inferior-lisp-mode-hook 'de/lisps-mode-hook)

(provide 'setup-common-lisp)
