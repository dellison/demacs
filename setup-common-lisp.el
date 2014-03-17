(install-if-needed 'slime)

(when (equal system-type 'darwin)
  (setenv "LANG" "en_US.UTF-8")
  (setq inferior-lisp-program "/usr/local/bin/sbcl")
  (setq slime-lisp-implementations '((sbcl ("/usr/local/bin/sbcl") :coding-system utf-8-unix)))
  (require 'slime)
  (slime-setup))

(provide 'setup-common-lisp)
