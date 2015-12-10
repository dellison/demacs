(require 'org)

;; Babel setup
(setq org-babel-load-languages
      '((emacs-lisp . t)
	(perl . t)
	(python . t)
	(sh . t)))

;; cosmetic stuff
(setq org-ellipsis " ⋯ ▼"
      org-export-dispatch-use-expert-ui t)

;; my org-mode setup and capturing notes
(setq org-directory "~/dorg"
      org-default-notes-file (concat org-directory "/notes.org"))
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates
      '(("e" "Emacs" entry (file (concat demacs-directory "todo.org"))
	 "* TODO %?\n  Captured at %T")
	("m" "Movie" entry (file (concat org-directory "/movies.org"))
	 "* WATCHME %t %?\n  %a")
	("n" "Note" entry (file (concat org-directory "/notes.org"))
	 "* %?\n  Captured at %T")
	("t" "Todo" entry (file (concat org-directory "/todo.org"))
	 "* TODO %?\n  Captured at %T")
	("g" "Grocery Store" item (file (concat org-directory "/groceries.org"))
	 "- %?")))

(add-hook 'org-capture-mode-hook
	  (defun setup-org-capture-mode ()
	    (if (fboundp 'evil-mode)
		(evil-emacs-state))))

(defun de/org-mode-hook ()
  "setup for org mode"
  (message "setting up org mode!")
  (define-key evil-insert-state-local-map
    (kbd "C-<return>") 'org-insert-heading-after-current)
  (define-key evil-emacs-state-local-map
    (kbd "C-<return>") 'org-insert-heading-after-current)
  (define-key evil-normal-state-local-map
    (kbd "C-<return>") 'org-insert-heading-after-current)
  (local-set-key (kbd "C-RET") 'org-insert-heading-after-current))

(add-hook 'org-mode-hook 'de/org-mode-hook)

(defun de/surround-region-with-org-comment (beg end)
  (interactive "r")
  (save-excursion
    (goto-char end)
    (insert "#+END_COMMENT\n")
    (goto-char beg)
    (insert "#+BEGIN_COMMENT\n")))

(defun de/org-latex-skip-line ()
  (interactive)
  (beginning-of-line)
  (insert "#+LaTeX: \\\\ \\: \\\\\n"))

(defun de/convert-decimal-to-roman (x &optional s)
  (let ((st (if s s ""))
	(nums '((1 . "I") (4 . "IV") (5 . "V") (9 . "IX")
		(10 . "X") (40 . "XL") (50 . "L") (90 . "XC")
		(100 . "C") (400 . "CD") (500 . "D") (900 . "CM")
		(1000 . "M"))))
    (if (zerop x)
	st
      (let ((i 1)
	    (m 1)
	    (ns (mapcar 'car nums)))
	(catch 'done
	  (while (<= i x)
	    (if (> (nth i ns) x)
		(throw 'done x)
	      (setq m (nth i ns))
	      (incf i))))
	(convert-decimal-to-roman (- x m)
				  (concat st (cdr (assoc m nums))))))))

(provide 'setup-org)
