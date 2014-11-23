;; this is some general setup for Lisp dialects:
;; Emacs Lisp, Clojure, Common Lisp, Scheme

(use-package paredit)
(use-package evil-paredit)
(use-package rainbow-delimiters)
(use-package rainbow-identifiers
  :ensure rainbow-identifiers
  )

(use-package rainbow-blocks
  :ensure rainbow-blocks)

(defun de/toggle-lisp-highlighting ()
  "Toggles between `rainbow-blocks-mode' and `rainbow-delimiters-mode'"
  (interactive)
  (cond
   (rainbow-blocks-mode
    (rainbow-blocks-mode-disable)
    (rainbow-identifiers-mode -1)
    (rainbow-delimiters-mode-enable))
   ((and (null rainbow-blocks-mode) (null rainbow-identifiers-mode))
    (rainbow-identifiers-mode 1)
    (rainbow-blocks-mode -1))
   (rainbow-identifiers-mode
    (rainbow-blocks-mode-enable)
    (rainbow-delimiters-mode-disable))))

(require 'evil)
(require 'paredit)
(require 'rainbow-delimiters)

(defun de/lisps-mode-hook ()
  "generalized hook for working with lisp languages"
  (rainbow-delimiters-mode 1)
  (require 'evil-paredit)
  (enable-paredit-mode)
  (evil-paredit-mode t)
  (local-set-key (kbd "C-c lh") 'de/toggle-lisp-highlighting)
  (define-key evil-visual-state-local-map "x" 'evil-delete-char)
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

(provide 'setup-lisps)
