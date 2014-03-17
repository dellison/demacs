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

(provide 'setup-prolog)
