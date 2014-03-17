(require 'flymake)
(require 'jedi)

(when (eq system-type 'darwin)
  (setenv "PATH" (concat "/usr/local/bin:"
			 "/usr/local/lib/:"
			 (getenv "PATH")))
  (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH")
			       "/usr/local/lib/python2.7/site-packages"))
  (setq python-shell-interpreter "/usr/local/bin/python")
  (setq jedi:server-command
	(list "/usr/local/bin/python" jedi:server-script)
	)
  (setq pylint "/usr/local/share/python/epylint"))

(mapc 'install-if-needed '(jedi
			   auto-complete))

(defvar de/python-breakpoint-string "import pdb; pdb.set_trace() ## DEBUG ##"
  "Python breakpoint string.")

(defun de/python-insert-breakpoint ()
  "Inserts a pdb breakpoint at point."
  (interactive)
  (back-to-indentation)
  (split-line) ;; to preserve indentation?
  (insert de/python-breakpoint-string))

(defun de/run-this-python-script-as-compile ()
  "Runs python script in current buffer using M-x `compile'."
  (interactive)
  (let ((run-cmd (read-from-minibuffer "Run: " (concat "python " (car (last (split-string (buffer-file-name) "/"))) " "))))
    (compile run-cmd t)))

(add-hook 'python-mode-hook
	  (defun de-python-mode-hook ()
	    ;(flymake-activate)
	    ;(auto-complete-mode)
	    (setq ac-candidate-limit 5)
	    (setq ac-timer 1.0)
	    ;(autopair-mode)
	    (jedi:setup)
	    (setq jedi:complete-on-dot t)
	    (setq jedi:tooltip-method nil)
            (local-set-key "\C-cd" 'jedi:show-doc)
            (local-set-key (kbd "M-SPC") 'jedi:complete)
            (local-set-key (kbd "M-.") 'jedi:goto-definition)
	    (setq jedi:get-in-function-call-delay 2000)
	    (local-set-key (kbd "C-c rp") 'de/run-this-python-script-as-compile)
	    (local-set-key (kbd "C-c pb") 'de/python-insert-breakpoint)
	    (define-key evil-insert-state-local-map (kbd "S-SPC") (lambda () (interactive) (insert "_")))))

;; Flymake settings for Python
(defun flymake-python-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "epylint" (list local-file))))

(defun flymake-activate ()
  "Activates flymake when real buffer and you have write access"
  (if (and
       (buffer-file-name)
       (file-writable-p buffer-file-name))
      (progn
        (flymake-mode t)
        ;; this is necessary since there is no flymake-mode-hook...
        ;(local-set-key (kbd "C-c n") 'flymake-goto-next-error)
        ;(local-set-key (kbd "C-c p") 'flymake-goto-prev-error)
	)))

(defun de-echo-epylint-error-for-current-line ()
  "show epylint error for current line in echo area"
  (when (save-excursion (back-to-indentation) (get-char-property (point) 'flymake-overlay))
    (let ((help (get-char-property (save-excursion (back-to-indentation) (point)) 'help-echo)))
      (if help (message "%s" help)))))

(add-hook 'post-command-hook 'de-echo-epylint-error-for-current-line)


(add-to-list 'flymake-allowed-file-name-masks
             '("\\.py\\'" flymake-python-init))

(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list (expand-file-name pylint "") (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pylint-init)))

(provide 'setup-python)
