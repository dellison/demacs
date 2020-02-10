;; this is some general setup for Lisp dialects:
;; Emacs Lisp, Clojure, Common Lisp, Scheme

(use-package paredit
  :ensure paredit)

(use-package evil-paredit
  :ensure evil-paredit)

(use-package rainbow-delimiters
  :ensure rainbow-delimiters)

(use-package rainbow-identifiers
  :ensure rainbow-identifiers)

(use-package rainbow-blocks
  :ensure t

  :config
  ;; (set-face-attribute 'rainbow-blocks-depth-1-face )
  )

(defun de/toggle-lisp-highlighting ()
  "Toggles between `rainbow-blocks-mode' and `rainbow-delimiters-mode'"
  (interactive)
  (cond
   (rainbow-blocks-mode
    (rainbow-blocks-mode-disable)
    (rainbow-identifiers-mode -1)
    (rainbow-delimiters-mode-enable)
    (message "Using normal highlighting, with delimiters."))
   ((and (null rainbow-blocks-mode) (null rainbow-identifiers-mode))
    (rainbow-identifiers-mode 1)
    (rainbow-blocks-mode -1)
    (message "Highlighting individual identifiers."))
   (rainbow-identifiers-mode
    (rainbow-blocks-mode-enable)
    (rainbow-delimiters-mode-disable)
    (message "Highlighting by s-expression."))))

(defun de/lisps-mode-hook ()
  "generalized hook for working with lisp languages"
  (rainbow-delimiters-mode 1)
  (require 'evil-paredit)
  (enable-paredit-mode)
  (evil-paredit-mode t)
  (local-set-key (kbd "C-c lh") 'de/toggle-lisp-highlighting)
  (local-set-key (kbd "C-M-l") 'paredit-forward-slurp-sexp)
  (local-set-key (kbd "C-M-h") 'paredit-forward-barf-sexp)
  (define-key evil-visual-state-local-map "x" 'evil-delete-char)
  (define-key evil-emacs-state-local-map (kbd "M-J") 'paredit-join-sexps)
  (define-key evil-insert-state-local-map (kbd "M-J") 'paredit-join-sexps)
  (define-key evil-emacs-state-local-map (kbd "S-SPC")
    (lambda () (interactive) (insert "-")))
  (define-key evil-insert-state-local-map (kbd "S-SPC")
    (lambda () (interactive) (insert "-")))
  ;; (aggressive-indent-mode 1)
  
  ;; (make-local-variable 'hippie-expand-try-functions-list)
  ;; (setq hippie-expand-try-functions-list
  ;; 	'(try-complete-file-name-partially
  ;; 	  try-complete-file-name
  ;; 	  try-expand-all-abbrevs
  ;; 	  try-expand-list
  ;; 	  try-expand-dabbrev
  ;; 	  try-expand-dabbrev-all-buffers
  ;; 	  try-expand-dabbrev-from-kill
  ;; 	  try-complete-lisp-symbol-partially
  ;; 	  try-complete-lisp-symbol))
  )

(defun de/clean-buffer-parens ()
  "Removes any space/newlines from between closing parens
in the current buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward ")[[:space:]\n]+)" nil t)
      (replace-match "))" nil nil)
      (beginning-of-line))))

(defun de/evil-paredit-open-below ()
  "Like `evil-open-below', but moves outside the current s-expression first"
  (interactive)
  (paredit-forward-up)
  (newline-and-indent)
  (paredit-open-round))

(provide 'setup-lisps)
