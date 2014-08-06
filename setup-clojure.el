(unless (package-installed-p 'cider)
  (package-install 'cider))

(when (eq system-type 'darwin)
  (setenv "PATH" (concat (getenv "PATH") ":/Users/david/tools/leiningen")))

(defun de/clojure-mode-hook ()
  (cider-turn-on-eldoc-mode)
  (paredit-mode 1)
  (add-hook before-save-hook 'de/clean-buffer-parens nil 'local)
  (define-key evil-insert-state-local-map (kbd "S-SPC") (lambda () (interactive) (insert "-"))))

(defun de/cider-repl-mode-hook ()
  "setup hook run running a clojure REPL with CIDER"
  (paredit-mode 1)
  (clojure-mode-font-lock-setup)
  (define-key evil-insert-state-local-map (kbd "S-SPC") (lambda () (interactive) (insert "-"))))

(require 'cider)

;; (setq cider-repl-use-pretty-printing t
;;       cider-repl-use-clojure-font-lock t)

(add-hook 'clojure-mode-hook 'de/clojure-mode-hook)
(add-hook 'cider-repl-mode-hook 'de/cider-repl-mode-hook)

(provide 'setup-clojure)
