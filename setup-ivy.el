(use-package smex
  :ensure t)

(use-package swiper
  :ensure t
  :config
  (ivy-mode 1)

  (global-set-key (kbd "C-M-s") #'swiper))

;; why use ido when you can use ivy?
(defalias 'ido-completing-read 'ivy-completing-read)

(defun de/get-keybinding (cmd)
  "Return the keybinding for CMD, if it exists."
  (let ((binding (substitute-command-keys (format "\\[%s]" cmd))))
    (unless (string-match "^M-x " binding)
      binding)))

(defun de/keybound-p (cmd)
  (let ((binding (substitute-command-keys (format "\\[%s]" cmd)))
	(mx (format "M-x %s" cmd)))
    (not (string= mx binding))))


;; TODO: maybe speed this up by getting symbols from the major &
;; minor mode maps?

(defun de/counsel-M-x-only-bound ()
  "Like counsel-M-x, but only include commands that are bound to a
key or key sequence."
  (interactive)
  (let ((symbols '()))
    (mapatoms
     (lambda (x)
       (when (de/keybound-p x)
	 (push (symbol-name x) symbols))))
    (ivy-read (counsel--M-x-prompt) symbols ;; obarray
	      :predicate 'de/keybound-p
	      :require-match t
	      ;; :history
	      :action
	      (lambda (cmd)
		(when (featurep 'smex)
		  (smex-rank (intern cmd)))
		(let ((prefix-arg current-prefix-arg))
		  (setq real-this-command
			(setq this-command (intern cmd)))
		  (command-execute (intern cmd) 'record)))
	      :sort t
	      :keymap counsel-describe-map
	      ;; :initial-input
	      :caller 'counsel-M-x)))
(global-set-key (kbd "C-c M-x") 'de/counsel-M-x-only-bound)

(defun de/counsel-git-grep ()
  (interactive)
  (if (region-active-p)
      (counsel-git-grep "git --no-pager grep --full-name -n --no-color -i -e \"%s\""
			(buffer-substring (region-beginning) (region-end)))
    (counsel-git-grep)))


(global-set-key (kbd "C-c g g") #'de/counsel-git-grep)


(use-package counsel
  :ensure t

  :config
  (setq counsel-find-file-at-point t
	ivy-height 13
	ivy-use-selectable-prompt t)

  ;; written in the style of (kinda copied from) ivy-format-function-arrow
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
  :bind (("M-y" . browse-kill-ring)
	 :map browse-kill-ring-mode-map
	 ("j" . browse-kill-ring-forward)
	 ("k" . browse-kill-ring-previous)
	 ("n" . browse-kill-ring-forward)
	 ("p" . browse-kill-ring-previous)))

(provide 'setup-ivy)
