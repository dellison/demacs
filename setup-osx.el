(setq mac-command-modifier 'meta)

(global-set-key (kbd "C-c fs") 'toggle-fullscreen)

(defun dired-finder ()
  "Opens the current directory (in dired mode) in Finder"
  (interactive)
  (shell-command "open ."))
(add-hook 'dired-mode-hook (lambda () (global-set-key [f12] 'dired-finder)))

(defun finder ()
  "Launch the finder in the current directory and select current file"
  (interactive)
  (shell-command
   (concat "open -R " (convert-standard-filename buffer-file-name))))
(global-set-key [f12] 'finder)

(setq ispell-program-name "/usr/local/bin/aspell")

(push "/usr/local/bin" exec-path) ; this is required by DocView mode, I guess...

;; (use-package exec-path-from-shell
;;   :ensure exec-path-from-shell)

(provide 'setup-osx)
