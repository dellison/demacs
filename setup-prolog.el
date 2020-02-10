(autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
(autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
(setq prolog-system 'swi)
(setq prolog-program-name 
      (quote (((getenv "EPROLOG") (eval (getenv "EPROLOG")))
	      (eclipse "eclipse")
	      (mercury nil)
	      (sicstus "sicstus")
	      (swi "swipl")
	      (gnu "gprolog")
	      (xsb "xsb")
	      (t "pl"))))

(defun de/switch-to-prolog ()
  (interactive)
  (prolog-goto-prolog-process-buffer))

(defalias 'switch-to-prolog 'de/switch-to-prolog)

(defun de/prolog-mode-hook ()
  (setq comment-start "%%")
  (define-key evil-insert-state-local-map (kbd "S-SPC") 'de/prolog-shift-space)
  (define-key evil-emacs-state-local-map (kbd "S-SPC") 'de/prolog-shift-space)
  ;; (smartparens-mode 1)
  )

(add-hook 'prolog-mode-hook 'de/prolog-mode-hook)

(defun de/prolog-shift-space ()
  (interactive)
  (cond ((looking-back ")")
	 (insert " :-")
	 (newline-and-indent))
	((looking-back ") ")
	 (insert ":-")
	 (newline-and-indent))
	((looking-back "^")
	 (insert ":- "))
	((looking-back "[A-Za-z0-9] ")
	 (insert ":-")
	 (newline-and-indent))
	(t
	 (insert "_")))

  ;; (if (string-match-p ")" (string (preceding-char)))
  ;;     (insert " :-")
  ;;   (insert "_"))
  )

(use-package ediprolog
  :ensure t

  :bind ((:map prolog-mode-map
	       ("C-c C-c" . ediprolog-dwim)
	       ("C-c M-o" . ediprolog-remove-interactions)
	       ("?" . de/ediprolog-query-or-question-mark)))

  :config
  (setq ediprolog-prefix "%@ ")

  (defun de/ediprolog-query-or-question-mark ()
    (interactive)
    (if (prolog-in-string-or-comment)
	(if (looking-back "^\s*")
	    (insert "?- ")
	  (insert "?"))
      (if (looking-back "^\s*")
	  (progn
	    (prolog-insert-comment-block)
	    (insert "?- "))
	(insert "?"))))

  (defun prolog-insert-comment-block ()
    "Insert a PceEmacs-style comment block like /* - - ... - - */ "
    (interactive)
    (let ((dashes "-"))
      (dotimes (_ 36) (setq dashes (concat "- " dashes)))
      (insert (format "/* %s\n\n%s */" dashes dashes))
      (forward-line -1)
      (indent-for-tab-command))))


(use-package ob-prolog
  :ensure t

  :init
  (defun prolog-program-name ()
    (car (alist-get prolog-system prolog-program-name))))

(provide 'setup-prolog)
