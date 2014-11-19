(autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
(autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
(setq prolog-system 'swi)
(setq prolog-program-name 
      (quote (((getenv "EPROLOG") (eval (getenv "EPROLOG")))
	      (eclipse "eclipse")
	      (mercury nil)
	      (sicstus "sicstus")
	      (swi "/opt/local/bin/swipl")
	      (gnu "gprolog")
	      (xsb "xsb")
	      (t "pl"))))

(defun de/switch-to-prolog ()
  (interactive)
  (prolog-goto-prolog-process-buffer))

(defalias 'switch-to-prolog 'de/switch-to-prolog)

(defun de/prolog-mode-hook ()
  (define-key evil-insert-state-local-map (kbd "S-SPC") 'de/prolog-contextual-shift-space)
  (define-key evil-emacs-state-local-map (kbd "S-SPC") 'de/prolog-contextual-shift-space)
  (smartparens-mode 1))

(add-hook 'prolog-mode-hook 'de/prolog-mode-hook)

(defun de/prolog-contextual-shift-space ()
  (interactive)
  (if (string-match-p ")" (string (preceding-char)))
      (insert " :-")
    (insert "_")))

(provide 'setup-prolog)
