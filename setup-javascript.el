(use-package js2-mode
  :ensure t

  :init (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

  :config (add-hook 'js2-mode-hook 'de/js-mode-hook))

(use-package json-mode
  :ensure t)

(defun de/js-mode-hook ()
  "Setup for javascript"
  (smartparens-mode 1)
  (show-smartparens-mode 1))

(provide 'setup-javascript)
