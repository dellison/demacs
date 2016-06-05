;; 
;; LaTex setup
;;

(use-package tex-site
  :ensure auctex)

(require 'doc-view)

(defun de/latex-mode-hook ()
  "setup for LaTeX"
  (TeX-PDF-mode-on)
  (show-smartparens-mode 1)
  (define-key evil-emacs-state-local-map (kbd "S-SPC")
    (lambda () (interactive) (insert "-")))
  (define-key evil-insert-state-local-map (kbd "S-SPC")
    (lambda () (interactive) (insert "-")))
  (message "setting up LaTeX!"))

(defun de/doc-view-mode-hook ()
  "setup stuff for viewing .dvi and .pdf"
  (auto-revert-mode 1))

(define-key doc-view-mode-map "k" 'doc-view-previous-line-or-previous-page)
(define-key doc-view-mode-map "j" 'doc-view-next-line-or-next-page)
(define-key doc-view-mode-map "l" 'image-forward-hscroll)
(define-key doc-view-mode-map "h" 'image-backward-hscroll)


(add-hook 'LaTeX-mode-hook 'de/latex-mode-hook)
(add-hook 'doc-view-mode-hook 'de/doc-view-mode-hook)

(provide 'setup-latex)
