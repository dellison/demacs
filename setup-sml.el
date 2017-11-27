(use-package sml-mode
  :ensure t

  :config
  (when (eq system-type 'darwin)
    (setenv "PATH" (concat (getenv "PATH") ":/usr/local/smlnj/bin"))
    (add-to-list 'exec-path "/usr/local/smlnj/bin")))

(provide 'setup-sml)
