;; 
;; LaTex setup
;;

(use-package tex-site
  :ensure auctex)

(defun de/latex-mode-hook ()
  "setup for LaTeX"
  (TeX-PDF-mode-on)
  (smartparens-mode 1)
  (show-smartparens-mode 1)
  (define-key evil-insert-state-local-map (kbd "\"")
    (lambda ()
      (interactive)
      (insert "``''")
      (forward-char -2)))
  (define-key evil-emacs-state-local-map (kbd "\"")
    (lambda ()
      (interactive)
      (insert "``''")
      (forward-char -2)))
  (message "setting up LaTeX!"))

(defun de/doc-view-mode-hook ()
  "setup stuff for viewing .dvi and .pdf"
  (auto-revert-mode 1))

(add-hook 'LaTeX-mode-hook 'de/latex-mode-hook)
(add-hook 'doc-view-mode-hook 'de/doc-view-mode-hook)

(provide 'setup-latex)
