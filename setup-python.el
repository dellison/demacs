(when (eq system-type 'darwin)
  (setenv "PATH" (concat "/usr/local/bin:"
			 "/usr/local/lib/:"
			 (getenv "PATH")))
  (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH")
			       "/usr/local/lib/python2.7/site-packages"))
  (setq python-shell-interpreter "/usr/local/bin/python"))

(defvar de/python-breakpoint-string "import pdb; pdb.set_trace() ## DEBUG ##"
  "Python breakpoint string.")

(defun de/python-insert-breakpoint ()
  "Inserts a pdb breakpoint at point."
  (interactive)
  (save-excursion
    (back-to-indentation)
    (split-line) ;; to preserve indentation?
    (insert de/python-breakpoint-string)))

(defun de/run-this-python-script-as-compile ()
  "Runs python script in current buffer using M-x `compile'."
  (interactive)
  (let ((run-cmd (read-from-minibuffer "Run: " (concat "python " (car (last (split-string (buffer-file-name) "/"))) " "))))
    (compile run-cmd t)))

(add-hook 'python-mode-hook
	  (defun de/python-mode-hook ()
	    ;; (setq python-indent-guess-indent-offset nil)
	    (local-set-key (kbd "C-c rp") 'de/run-this-python-script-as-compile)
	    (local-set-key (kbd "C-c pb") 'de/python-insert-breakpoint)
	    (local-set-key (kbd "C-c pd") 'de/python-insert-breakpoint)
	    (local-set-key (kbd "S-SPC") (lambda () (interactive) (insert "_")))))



(provide 'setup-python)
