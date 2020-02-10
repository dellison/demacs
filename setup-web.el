(use-package web-mode
  :ensure web-mode
  :mode "\\.html\\'")

(use-package markdown-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package restclient
  :ensure t

  :bind (:map restclient-mode-map
	 ("C-c C-c" . restclient-http-send-current-stay-in-window)))

(use-package ob-restclient
  :ensure t)

(provide 'setup-web)
