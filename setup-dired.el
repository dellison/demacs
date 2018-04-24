(use-package dired
  :bind (:map dired-mode-map
	 ("<SPC>" . nil)
	 ("f" . de/dired-find-here)
	 ("j" . dired-next-line)
	 ("k" . dired-previous-line)
	 ("J" . dired-goto-file)
	 ("K" . de/dired-kill-lines-or-sibdir)
	 ("M-<" . de/dired-up-to-top)
	 ("M->" . de/dired-down-to-bottom))
  
  :config
  (require 'dired-x)
  (setq dired-listing-switches "-hal"
	dired-dwim-target t)
  (defun de/dired-up-to-top ()
    (interactive)
    (beginning-of-buffer)
    (dired-next-line 2))
  (defun de/dired-down-to-bottom ()
    (interactive)
    (end-of-buffer)
    (dired-next-line -1))
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
    (local-unset-key (kbd "SPC")) ; so that evil-leader works
    (local-unset-key (kbd "M-o"))) ; I prefer other-window to dired-omit-mode
  (add-hook 'dired-mode-hook 'de/dired-mode-hook)
  (add-hook 'dired-load-hook 'de/dired-mode-hook))

(provide 'setup-dired)
