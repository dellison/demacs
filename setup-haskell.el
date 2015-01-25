;; haskell!
(use-package haskell-mode
  :commands (haskell-mode)
  :init
  (add-to-list 'auto-mode-alist '("\\.l?hs$" . haskell-mode))
  :config
  (progn
    (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
    (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
    (setq haskell-font-lock-symbols t) ;; pretty haskell
    (defun de/ghci ()
      "Run Haskell!"
      (interactive)
      (run-haskell "-XNoMonomorphismRestriction"))))
