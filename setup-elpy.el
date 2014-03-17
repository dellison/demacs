(install-if-needed 'elpy)
(install-if-needed 'auto-complete)

(require 'auto-complete)

(when (fboundp 'exec-path-from-shell-copy-env)
  (exec-path-from-shell-copy-env "PYTHONPATH"))

(defun de/show-flymake-error-in-minibuffer ()
  "duh"
  (when (save-excursion (back-to-indentation) (get-char-property (point) 'flymake-overlay))
    (let ((help (get-char-property (save-excursion (back-to-indentation) (point)) 'help-echo)))
      (if help (message "%s" help)))))


(add-hook 'python-mode-hook
	  (defun de/python-elpy-hook ()
	    (add-hook 'post-command-hook 'de/show-flymake-error-in-minibuffer)))

(elpy-enable)
(elpy-use-ipython)

(require 'elpy)

(provide 'setup-elpy)
