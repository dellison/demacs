(require 'dired)
(setq dired-listing-switches "-hal")

(require 'dired-x)

(use-package dired-details
  :ensure dired-details)

(define-key dired-mode-map (kbd "SPC") nil)

(require 'dired-details)
(setq dired-details-hidden-string "--- ")

(define-key dired-mode-map (kbd "<SPC>") nil)
(define-key dired-mode-map "f" 'de/dired-find-here)
;; use j and k for going up and down
(define-key dired-mode-map (kbd "j") 'dired-next-line)
(define-key dired-mode-map (kbd "k") 'dired-previous-line)
;; (define-key dired-mode-map (kbd "K") 'dired-do-kill-lines)
(define-key dired-mode-map (kbd "K") #'de/dired-kill-lines-or-sibdir)
(when (fboundp 'evil-mode)
  (define-key evil-normal-state-local-map "(" 'dired-details-toggle)
  (define-key evil-motion-state-local-map (kbd "0") nil)
  (define-key evil-motion-state-local-map (kbd "RET") nil))

(defun de/dired-find-here (wildcard)
  (interactive "srun `find' recursively with wildcard: ")
  (find-name-dired default-directory wildcard))

(defun de/dired-kill-lines-or-sibdir (&optional arg fmt)
  ""
  (interactive "P")
  (let ((looking-at-subdir (dired-get-subdir)))
    (if looking-at-subdir
	(progn
	  (dired-kill-subdir)
	  (pop-global-mark))
      (dired-do-kill-lines))))

(defun de/dired-mode-hook ()
  "dired mode hook"
  ;; (load "dired-x")
  (local-set-key (kbd "(") 'dired-details-toggle)
  (local-unset-key (kbd "SPC"))		; so that evil-leader works
  (local-unset-key (kbd "M-o")) ; I prefer other-window to dired-omit-mode
  (local-unset-key " ")		; :( it doesn't work, i want leader
  )

(add-hook 'dired-mode-hook 'de/dired-mode-hook)
(add-hook 'dired-load-hook 'de/dired-mode-hook)

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
