(mapc 'install-if-needed '(ein))

(add-hook 'ein:connect-mode-hook
	  (defun de/ein-connect-mode-gook ()
	    (ein:jedi-setup)))

(require 'ein)

(provide 'ipython-setup)
