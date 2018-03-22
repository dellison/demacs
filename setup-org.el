(require 'org)

;; (use-package org-plus-contrib
;;   :ensure t)

;; Babel setup
(setq org-babel-load-languages
      '((emacs-lisp . t)
	(julia . t)
	(perl . t)
	(python . t)
	(sh . t)))

;; cosmetic stuff
(setq org-ellipsis " ..."
      org-export-dispatch-use-expert-ui t)

;; indentation
(setq org-indent-indentation-per-level 1)
;; for some reason, changing org-indent doesn't work until after initialization
(add-hook 'after-init-hook
	  (lambda ()
	    (require 'org-indent)
	    (set-face-attribute 'org-indent nil
				:underline nil
				:foreground "#656555"
				:background "#383838")))

;; inline latex images should be large and black text, white background
(setq org-format-latex-options
      '(:foreground "Black"
	:background "White"
	:scale 2.5
	:matchers '("begin" "$1" "$" "$$" "\\(" "\\[")))

;; my org-mode setup and capturing notes
(setq org-directory "s:/dorg"
      org-default-notes-file (concat org-directory "/notes.org"))

(global-set-key (kbd "C-c a") #'org-agenda)

(defun de/org-agenda-hook ()
  (hl-line-mode 1))

(add-hook 'org-agenda-mode-hook #'de/org-agenda-hook)

(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c l") #'org-store-link)


;; (setq org-capture-templates
;;       '(("e" "Emacs" entry (file (concat demacs-directory "/todo.org"))
;; 	 "* TODO %?\n  Captured at %T")
;; 	("m" "Movie" entry (file (concat org-directory "/movies.org"))
;; 	 "* WATCHME %t %?\n  %a")
;; 	("n" "Note" entry (file (concat org-directory "/notes.org"))
;; 	 "* %?\nlink: %a\nCaptured at %T")
;; 	("t" "Todo" entry (file (concat org-directory "/todo.org"))
;; 	 "* TODO %?\n  Captured at %T")
;; 	("g" "Grocery Store" item (file (concat org-directory "/groceries.org"))
;; 	 "- %?")))

(setq org-capture-templates
      '(
	("b" "Book" entry
	 (file "books.org")
	 "* TOREAD\n%U\n")
	
	("e" "Emacs" entry
	 (file "todo.org")
	 "* TODO %?\n  Captured at %T")

	("l" "Link" entry
	 (file "links.org")
	 "* %a\n%U\n%?")
	
	("m" "Movie" entry
	 (file "movies.org")
	 "* WATCHME %t %?\n%a")

	("n" "Note" entry
	 (file "notes.org")
	 "* %?\n%U\nLink: %a" :empty-lines 1)

	("t" "Todo" entry
	 (file "todo.org")
	 "* TODO %?\n  Captured at %T")

	("g" "Grocery Store" item (file "groceries.org")
	 "- %?")))


(add-hook 'org-capture-mode-hook
	  (defun setup-org-capture-mode ()
	    (if (fboundp 'evil-mode)
		(evil-emacs-state))))

;; (setq de/org-note-capture-template
;;       '("n" "Note" entry (file (concat org-directory "/notes.org"))
;; 	(string-join '("* %?\n%U\n"
;; 		       (when (eq major-mode 'elfeed-show-mode)
;; 			 "elfeed lol"
;; 			 ;; capture links (to elfeed article and url)
;; 			 )
;; 		       ;; (when (eq major-mode ))
;; 		       ) ))
;;       )



(defun de/org-set-tag ()
  "Wrapper for org-set-tag which keep tags in alphabetical order."
  (interactive)
  (counsel-org-tag)
  (org-set-tags-to (sort (org-get-local-tags) #'string<))
  (org-set-tags nil t))

(defun de/org-mode-hook ()
  "setup for org mode"
  (hl-line-mode 1)
  (yas-minor-mode 1)
  (define-key evil-insert-state-local-map
    (kbd "C-<return>") 'org-insert-heading-after-current)
  (define-key evil-emacs-state-local-map
    (kbd "C-<return>") 'org-insert-heading-after-current)
  (define-key evil-normal-state-local-map
    (kbd "C-<return>") 'org-insert-heading-after-current)
  (local-set-key (kbd "C-RET") 'org-insert-heading-after-current)
  (local-set-key (kbd "M-q") #'org-fill-paragraph)
  (when (fboundp 'ivy-mode)
    (local-set-key (kbd "C-c C-q") (lambda ()
				     (interactive)
				     (save-excursion
				       (counsel-org-tag))))))

(add-hook 'org-mode-hook 'de/org-mode-hook)

(defun de/org-agenda-hook ()
  (hl-line-mode 1)
  (local-set-key "j" #'org-agenda-next-line)
  (local-set-key "k" #'org-agenda-previous-line)
  (local-set-key (kbd "C-c C-q") #'de/org-set-tag))

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

(defun de/revert-org-buffers ()
  "Reload all the org-mode buffers from disk."
  (interactive)
  (mapc
   (lambda (buf)
     (with-current-buffer buf
       (when (and buffer-file-name
		  (eq major-mode 'org-mode))
	 (revert-buffer nil t))))
   (buffer-list))
  (message "Reverted org buffers."))

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
