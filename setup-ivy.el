
(use-package swiper
  :ensure t
  :config
  (ivy-mode 1)

  (global-set-key (kbd "C-M-s") #'swiper))

;; why use ido when you can use ivy?
(defalias 'ido-completing-read 'ivy-completing-read)

(use-package counsel
  :ensure t

  :config
  (setq counsel-find-file-at-point t
	ivy-height 13)

  ;; written in the style of ivy-format-function-arrow
  (defun de/ivy-format-fn (cands)
    "Format candidate pairs in the minibuffer.
Point to the current match with an arrow -> and highlight its line."
    (ivy--format-function-generic
     (lambda (str)
       (ivy--add-face (concat " --> " str "\n") 'ivy-current-match))
     (lambda (str)
       (concat "     " str "\n"))
     cands
     ""))
  (setq ivy-format-function #'de/ivy-format-fn
	ivy-initial-inputs-alist '())

  (global-set-key (kbd "M-x") 'counsel-M-x)

  (set-face-attribute 'ivy-current-match nil
		      :background "#2B2B2B"
		      :foreground "#FFFFFF"))

(use-package browse-kill-ring
  :ensure t
  :config
  (global-set-key (kbd "M-y") #'browse-kill-ring)
  (define-key browse-kill-ring-mode-map "j" #'browse-kill-ring-forward)
  (define-key browse-kill-ring-mode-map "k" #'browse-kill-ring-previous))

(provide 'setup-ivy)
