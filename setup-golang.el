(use-package go-mode
  :ensure t

  :hook (go-mode . de/go-mode-hook)

  :config
  (defun de/go-mode-hook ()
    (setq tab-width 4)
    (yas-minor-mode-on))

  (setq gofmt-command "goimports"))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred)
  :config
  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks))

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package go-projectile
  :ensure t)

(provide 'setup-golang)
