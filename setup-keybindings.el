(global-set-key "\C-s" 'isearch-forward-regexp) ; search with regexes by default
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key (kbd "C-c gr") 'lgrep)
(global-set-key (kbd "C-c rg") 'rgrep)
(global-set-key (kbd "C-c sw") 'swap-windows)
(global-set-key (kbd "C-c dc") 'describe-char)
(global-set-key (kbd "C-c rr") 'replace-rectangle)
(global-set-key (kbd "C-c es") 'eshell)
(global-set-key (kbd "C-c tl") 'toggle-truncate-lines)
(global-set-key (kbd "C-c d RET") 'de/indent-to)
;; (global-set-key (kbd "C-c lw") 'toggle-truncate-lines)
;;    - "line wrap" mnemonic too
(global-set-key (kbd "C-c ws") 'whitespace-mode)
(global-set-key (kbd "M-/") 'hippie-expand)

(global-set-key "\C-ha" 'apropos) ; search for all symbols by default (instead of only commands)
(global-set-key (kbd "C-h c") 'apropos-command)  ; previously describe-key-briefly

(global-set-key (kbd "C-h C-f") 'describe-function)
(global-set-key (kbd "C-h C-v") 'apropos-variable)


(global-set-key (kbd "\C-x \C-b") 'ibuffer)
(global-set-key (kbd "\C-x\C-m") 'execute-extended-command) ;; per Steve Yegge's advice

(global-set-key (kbd "M-o") 'other-window)

(defalias 'qrr 'query-replace-regexp)
(defalias 'yes-or-no-p 'y-or-n-p)
(defalias 'wc 'count-words)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun beginning-of-line-or-indentation ()
  "Moves the cursor to the beginning of the line if at or before the indentation.
Otherwise, moves to the beginning of the line."
  (interactive)
  (cond ((= (save-excursion (beginning-of-line) (point)) (point))
	 (back-to-indentation))
	((>= (save-excursion (back-to-indentation) (point)) (point))
	 (beginning-of-line))
	((< (save-excursion (back-to-indentation) (point)) (point))
	 (back-to-indentation))))
(global-set-key "\C-a" 'beginning-of-line-or-indentation)

(global-set-key (kbd "M-j") (defun de/join-line ()
			      (interactive)
			      (save-excursion (join-line -1))))

(defun fast-move-down ()
  (interactive)
  (next-line 5))

(defun fast-move-up ()
  (interactive)
  (previous-line 5))

(defun scroll-forward-1 ()
  (interactive)
  (scroll-up 1)
  (next-line 1))

(defun scroll-back-1 ()
  (interactive)
  (scroll-down 1)
  (previous-line 1))

;; (global-set-key (kbd "C-S-n") 'fast-move-down)
;; (global-set-key (kbd "C-S-p") 'fast-move-up)

(global-set-key (kbd "C-S-n") 'scroll-forward-1)
(global-set-key (kbd "C-S-p") 'scroll-back-1)

(define-key occur-mode-map (kbd "v") 'occur-mode-display-occurrence)
(define-key occur-mode-map (kbd "n") 'next-line)
(define-key occur-mode-map (kbd "p") 'previous-line)

(defun google-search (query)
  "Search for something on Google."
  (interactive "sSearch Google for: ")
  (browse-url (format "https://www.google.com/#q=%s"
		      (replace-regexp-in-string " +" "\+" query))))
(global-set-key (kbd "C-c go") 'google-search)

(defun de/open-emacs-configuration-file ()
  "open a config file from demacs"
  (interactive)
  (find-file
   (ido-completing-read
    "Emacs configuration file: "
    (sort (file-expand-wildcards (format "%s/*.el" demacs-directory)) 'string<))))
;; (global-set-key (kbd "C-c de") 'de/open-emacs-configuration-file)

(defun de/visit-demacs ()
  "Use helm to visit an emacs configuration file."
  (interactive)
  (let ((default-directory demacs-directory))
    (helm-projectile)))
(global-set-key (kbd "C-c de") 'de/visit-demacs)

(when (fboundp 'evil-mode)
  (defun de/save-buffer-and-normal-state ()
    "save buffer, normal state"
    (interactive)
    (save-buffer)
    (evil-normal-state 1))
  (global-set-key (kbd "C-x C-s") 'de/save-buffer-and-normal-state)
  (define-key evil-insert-state-map (kbd "C-x C-s") 'de/save-buffer-and-normal-state))

(provide 'setup-keybindings)
