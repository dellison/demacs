(require 'eshell)
(require 'em-smart)
(setq eshell-where-to-jump 'begin)
(setq eshell-review-quick-commands nil)
(setq eshell-smart-space-goes-to-end t)

(defun de/eshell-setup-hook ()
  "setup for eshell"
  (paredit-mode 1)
  (eldoc-mode 1)
  (define-key evil-insert-state-local-map (kbd "S-SPC") (lambda () (interactive) (insert "-"))))

(add-hook 'eshell-setup-hook 'de/eshell-setup-hook)
