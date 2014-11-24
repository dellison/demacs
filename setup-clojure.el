(unless (package-installed-p 'cider)
  (package-install 'cider))

(setq cider-repl-use-pretty-printing t)

(when (eq system-type 'darwin)
  (setenv "PATH" (concat (getenv "PATH") ":/Users/david/tools/leiningen")))

(setq cider-repl-history-file (format "%s/.nrepl-history" demacs-directory))

(defun de/clean-buffer-parens-clojure ()
  "Removes any space/newlines from between closing parens
in the current buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[[:space:]\n]+\([\])]\)" nil t)
      (replace-match "\1\2" nil nil)
      (beginning-of-line))))

(defun de/clojure-mode-hook ()
  "setup hook for editing clojure code"
  (define-key evil-insert-state-local-map (kbd "S-SPC") (lambda () (interactive) (insert "-")))
  (cider-turn-on-eldoc-mode)
  (define-key evil-emacs-state-local-map (kbd "S-SPC") (lambda () (interactive) (insert "-"))))

(defun de/cider-repl-mode-hook ()
  "setup hook run running a clojure REPL with CIDER"
  (paredit-mode 1)
  (evil-paredit-mode 1)
  (rainbow-delimiters-mode 1)
  ;; (clojure-mode-font-lock-setup)
  (define-key evil-insert-state-local-map (kbd "S-SPC") (lambda () (interactive) (insert "-")))
  (define-key evil-emacs-state-local-map (kbd "S-SPC") (lambda () (interactive) (insert "-")))
  (cider-turn-on-eldoc-mode)
  (evil-emacs-state))


(require 'cider)

;;; I'm not sure about these:
;; (setq cider-repl-use-pretty-printing t
;;       cider-repl-use-clojure-font-lock t)

(add-hook 'clojure-mode-hook 'de/clojure-mode-hook)
(add-hook 'clojure-mode-hook 'de/lisps-mode-hook)

(add-hook 'cider-repl-mode-hook 'de/cider-repl-mode-hook)
(add-hook 'cider-repl-mode-hook 'de/lisps-mode-hook)

(provide 'setup-clojure)
