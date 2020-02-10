(when (eq system-type 'darwin)
  (setenv "PATH" (concat "/usr/local/bin:"
			 "/usr/local/lib/:"
			 (getenv "PATH")))
  (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH")
			       "/usr/local/lib/python2.7/site-packages"))
  (setq python-shell-interpreter "/usr/local/bin/python"))


(use-package conda
  :ensure t

  ;:bind ("C-c C" )

  :config
  (let ((conda-home (concat (getenv "HOME") "/anaconda3")))
    (setq conda-env-home-directory conda-home)
    (setenv "PATH" (concat (getenv "PATH") ":" conda-home "/condabin"))))

(use-package pyvenv
  :ensure t)

(use-package counsel-pydoc
  :ensure t

  :bind ((:map python-mode-map
	  ("C-c C-d" . nil)
	  ("C-c C-d d" . counsel-pydoc)
	  ("C-c C-d C-d" . counsel-pydoc))))

(use-package cython-mode
  :ensure t
  :mode (("\\.pyx\\'" . cython-mode)))

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

(defun de/python-mode-hook ()
  ;; (smartparens-mode 1)
  ;; (show-smartparens-mode 1)
  ;; (local-set-key (kbd "C-c rp") 'de/run-this-python-script-as-compile)
  ;; (local-set-key (kbd "C-c pb") 'de/python-insert-breakpoint)
  ;; (local-set-key (kbd "C-c pd") 'de/python-insert-breakpoint)
  (local-set-key (kbd "S-SPC") (lambda () (interactive) (insert "_"))))

(add-hook 'python-mode-hook 'de/python-mode-hook) 

(provide 'setup-python)
