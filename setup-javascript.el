(use-package js2-mode
  :ensure js2-mode
  :init
  (progn
    (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))
  :config
  (progn
    (add-hook 'js2-mode-hook 'de/js-mode-hook)))

(use-package json-mode
  :ensure json-mode)

(defun de/js-mode-hook ()
  "Setup for javascript"
  (smartparens-mode 1)
  (show-smartparens-mode 1))

(provide 'setup-javascript)
