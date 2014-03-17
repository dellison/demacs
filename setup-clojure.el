(unless (package-installed-p 'cider)
  (package-install 'cider))

(when (eq system-type 'darwin)
  (setenv "PATH" (concat (getenv "PATH") ":/Users/david/tools/leiningen")))

(defun de/cider-mode-hook ()
  (cider-turn-on-eldoc-mode)
  (paredit-mode 1))

(add-hook 'clojure-mode-hook 'de/cider-mode-hook)
(add-hook 'cider-repl-mode-hook 'de/cider-mode-hook)

(require 'cider)

(provide 'setup-clojure)
