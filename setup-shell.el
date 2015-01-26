
;(use-package exec-path-from-shell)

(when (fboundp 'exec-path-from-shell-copy-env)
  (exec-path-from-shell-copy-env "PATH"))

(add-hook 'shell-mode-hook 
	  (defun de/shell-mode-hook ()
	    "Hook for running shells with shell mode"
	    (compilation-shell-minor-mode t)))

(defun run-shell-in-current-directory (s)
  "Opens a new shell buffer in the current working directory. 
Prompts user for buffer name (defaults to *shell: <directory>*)"
  (interactive 
   (list (read-string 
	  (concat 
	   "Open shell with in new buffer (default *shell: "
	   default-directory
	   "*): "))))
   (if (equal "" s)
       (shell (concat "*shell: " default-directory "*"))
     (shell (concat "*" s "*"))))
(global-set-key (kbd "\C-c sh") 'run-shell-in-current-directory)

(defun set-exec-path-from-shell-path ()
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(provide 'setup-shell)
