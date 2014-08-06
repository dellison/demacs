(install-if-needed 'ess)

(when (eq system-type 'darwin)
  (setq inferior-julia-program-name "/Applications/Julia-0.2.1.app/Contents/Resources/julia/bin/julia-basic"))

(require 'ess-site)

(provide 'setup-ess)
