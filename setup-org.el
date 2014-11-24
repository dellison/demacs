(require 'org)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))

(use-package org
  :ensure org
  :init (progn
	  (setq org-startup-folded nil
		org-todo-keywords '((sequence "todo" "wait" "done")))
	  (if (eq system-type 'darwin)
	      (setq org-directory "~/org"
		    org-agenda-files '("~/org/todo.org"
				       "~/org/groceries.org"
				       "~/org/books.org"
				       "~/org/movies.org"
				       "~/org/lists.org"
				       "~/org/clms.org"
				       "~/org/records.org")
		    org-mobile-directory "~/Dropbox/org"
		    org-mobile-inbox-for-pull "~/org/index.org"))
	  (org-babel-do-load-languages 'org-babel-load-languages
				       '((emacs-lisp . t)
					 (R . t)
					 (python . t)
					 (sh . t))))
  :bind (("C-<RET>" . org-insert-heading-after-current)))

(defun de/org-mode-hook ()
  "setup for org mode"
  (message "setting up org mode!")
  (define-key evil-insert-state-local-map (kbd "C-<return>") 'org-insert-heading-after-current)
  (define-key evil-emacs-state-local-map (kbd "C-<return>") 'org-insert-heading-after-current)
  (define-key evil-normal-state-local-map (kbd "C-<return>") 'org-insert-heading-after-current)
  (local-set-key (kbd "C-RET") 'org-insert-heading-after-current))

(add-hook 'org-mode-hook 'de/org-mode-hook)

(provide 'setup-org)
  
