(defun de/ess-ins-underscore ()
  (interactive)
  (insert "_"))

(use-package ess
  :ensure ess
  :init
  (if (or (executable-find "R") (executable-find "julia"))
      (load "ess-site"))
  :bind
  (("TAB" . ess-indent-command)
   ("S-SPC" . de/ess-ins-underscore))
  :config
  (progn
    (when (eq system-type 'darwin)
      (setq inferior-julia-program-name "/Users/david/tools/julia-0.3/usr/bin/julia")
      ;; (add-to-list 'ess-tracebug-search-path "/Users/david/tools/julia-0.3/base/")
      
      (load "ess-site")
      ;; (add-to-list 'ess-tracebug-search-path "/Users/david/tools/julia-0.3/base/")
      (add-hook 'julia-mode-hook
		(defun de/julia-mode-hook ()
		  (local-set-key (kbd "S-SPC") 'de/ess-ins-underscore)
		  (local-set-key (kbd "TAB") 'ess-indent-command)))
      (add-hook 'inferior-ess-mode-hook 'de/ess-ins-underscore))))

(provide 'setup-ess)
