;; (mapc 'install-if-needed '(js2-mode))

(use-package js2-mode
  :ensure js2-mode
  :init
  (progn
    (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
    )
  :config
  (add-hook 'js2-mode-hook 'de/js-mode-hook)
  (define-key js2-mode-map "{" 'paredit-open-curly)
  (define-key js2-mode-map "}" 'paredit-close-curly-and-newline))

;; (use-package )

(defun de/js-mode-hook ()
  "Setup for javascript"
  ;; (de/paredit-nonlisp)
  )

(provide 'setup-javascript)
