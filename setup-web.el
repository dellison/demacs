(use-package web-mode
  :ensure web-mode
  ;; :mode "\\.html\\'"
  :config
  (progn
    (add-to-list auto-mode-alist ("\\.html\\'"))))

(use-package markdown-mode
  :ensure markdown-mode)
