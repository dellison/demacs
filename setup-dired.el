(require 'dired)
(setq de/dired-packages '(dired-details))

(mapc 'install-if-needed de/dired-packages)

(define-key dired-mode-map (kbd "SPC") nil)

(require 'dired-details)
(setq dired-details-hidden-string "--- ")

(add-hook 'dired-mode-hook 
	  (defun de/dired-mode-hook ()
	    "dired mode hook"
	    (local-set-key (kbd "(") 'dired-details-toggle)
	    (local-unset-key (kbd "<SPC>")) ; so that evil-leader works
	    (local-unset-key " ") ; :( it doesn't work, i want leader
	    (when (fboundp 'evil-mode)
	      (define-key evil-normal-state-local-map "(" 'dired-details-toggle))))

(defun dired-back-to-top ()
  (interactive)
  (beginning-of-buffer)
  (dired-next-line 2))

(defun dired-jump-to-bottom ()
  (interactive)
  (end-of-buffer)
  (dired-next-line -1))

(define-key dired-mode-map
  (vector 'remap 'beginning-of-buffer) 'dired-back-to-top)
(define-key dired-mode-map
  (vector 'remap 'end-of-buffer) 'dired-jump-to-bottom)

(provide 'setup-dired)
