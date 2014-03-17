;; this is some general setup for Lisp dialects:
;; Emacs Lisp, Clojure, Common Lisp, Scheme
;; 

(mapc 'install-if-needed '(paredit
			  evil-paredit
			  rainbow-delimiters))

(require 'evil)
(require 'paredit)
(require 'rainbow-delimiters)

(rainbow-delimiters-mode 1)

(defun de/lisps-mode-hook ()
  ;(auto-complete-mode)
  (rainbow-delimiters-mode 1)
  (local-set-key (kbd "RET") 'newline-and-indent)
  (require 'evil-paredit)
  (enable-paredit-mode)
  (evil-paredit-mode t))

(provide 'setup-lisps)
  
