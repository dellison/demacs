

(global-set-key (kbd "C-x C-b") 'ibuffer) ;; don't use default list-buffers

(add-hook 'ibuffer-mode-hook
	  (defun de/ibuffer-mode-hook ()
	    ;; ibuffer has its own ibuffer-find-file, for some reason
	    (local-set-key (kbd "C-x C-f") 'ido-find-file)))

(provide 'setup-ibuffer)
