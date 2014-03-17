(setq scheme-program-name "/usr/local/bin/scheme")

(require 'xscheme)

(defun de/scheme-mode-hook ()
  (paredit-mode 1)
  (define-key evil-normal-state-local-map (kbd "C-k") 'paredit-kill)
  (define-key evil-insert-state-local-map (kbd "C-k") 'paredit-kill)
  (define-key evil-insert-state-local-map (kbd "S-SPC") (lambda () (interactive) (insert "-"))))

(add-hook 'scheme-mode-hook 'de/scheme-mode-hook)
(add-hook 'scheme-interaction-mode-hook 'de/scheme-mode-hook)

(provide 'setup-scheme)
