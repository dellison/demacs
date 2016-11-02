
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
  (setq ivy-format-function #'de/ivy-format-fn)

  (global-set-key (kbd "M-x") 'counsel-M-x)

  (set-face-attribute 'ivy-current-match nil
		      :background "#2B2B2B"
		      :foreground "#FFFFFF"))


(provide 'setup-ivy)
