(setq isearch-lax-whitespace t
      isearch-regexp-lax-whitespace t
      search-whitespace-regexp "[ \t\r\n_-]+")

(global-set-key (kbd "C-s") #'isearch-forward-regexp)
(global-set-key (kbd "C-r") #'isearch-backward-regexp)

(defun de/isearch-forward-flexibly ()
  "incrementally search the buffer, but let SPC match anything"
  (interactive)
  (let ((search-whitespace-regexp ".*?"))
    (isearch-forward-regexp)))

(defun de/isearch-backward-flexibly ()
  "incrementally search the buffer, but let SPC match anything"
  (interactive)
  (let ((search-whitespace-regexp ".*?"))
    (isearch-backward-regexp)))

(global-set-key (kbd "C-c /") #'de/isearch-forward-flexibly)
(global-set-key (kbd "C-c ?") #'de/isearch-backward-flexibly)

;; occur-mode
(define-key occur-mode-map "j" #'next-line)
(define-key occur-mode-map "k" #'previous-line)
(define-key occur-mode-map "J" #'next-error)
(define-key occur-mode-map "K" #'previous-error)

(provide 'setup-isearch)
