(mapc 'install-if-needed '(haskell-mode))

(add-hook 'haskell-mode-hook
	  (defun de/haskell-mode-hook ()
	    (turn-on-haskell-doc-mode)
	    (turn-on-haskell-indent)))

(require 'haskell-mode)

(defalias 'ghci 'run-haskell)

(defun de/ghci ()
  (interactive)
  (run-haskell "-XNoMonomorphismRestriction"))

(provide 'setup-haskell)
