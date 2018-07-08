(use-package sml-mode
  :ensure t

  :bind (:map sml-mode-map
	 ("S-SPC" . de/sml-underscore))
  :config
  (defun de/sml-underscore ()
    (interactive)
    (insert "_"))
  (when (eq system-type 'darwin)
    (setenv "PATH" (concat (getenv "PATH") ":/usr/local/smlnj/bin"))
    (add-to-list 'exec-path "/usr/local/smlnj/bin")))

(provide 'setup-sml)
