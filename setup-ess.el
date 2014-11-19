(use-package ess
  :ensure ess
  :init (progn
	  (when (eq system-type 'darwin)
	    (setq inferior-julia-program-name "/Applications/Julia-0.2.1.app/Contents/Resources/julia/bin/julia-basic"))))

(provide 'setup-ess)
