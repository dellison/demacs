;; haskell!

(use-package haskell-mode
  :ensure haskell-mode
  :commands (haskell-mode)
  :config
  (add-to-list 'auto-mode-alist '("\\.l?hs$" . haskell-mode))
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
  (setq haskell-font-lock-symbols nil))

(provide 'setup-haskell)
