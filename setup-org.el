(require 'org)

(setq org-todo-keywords '((sequence "[ ]" "[X]")))

(org-babel-do-load-languages 'org-babel-load-languages
			     '((R . t)
			       (emacs-lisp . t)
			       (python . t)
			       (ruby . t)
			       (sh . t)
			       ))

(provide 'setup-org)
