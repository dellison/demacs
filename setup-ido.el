(require 'ido)

(setq ido-create-new-buffer 'always
      ido-enable-flex-matching t
      ido-enable-last-directory-history nil
      ido-record-commands nil
      ido-max-prospects 12
      ido-max-work-directory-list 0
      ido-max-work-file-list 0)

(ido-mode t)
(ido-everywhere t)

(use-package flx-ido
  :ensure flx-ido
  :init (flx-ido-mode 1))

(use-package ido-vertical-mode
  :ensure ido-vertical-mode
  :init (ido-vertical-mode 1))

(use-package ido-ubiquitous
  :ensure ido-ubiquitous
  :init (ido-ubiquitous-mode 1))

(add-hook 'ido-setup-hook
	  (defun de/ido-go-home ()
	    (define-key ido-file-completion-map
	      (kbd "~")
	      (lambda ()
		(interactive)
		(if (looking-back "/")
		    (insert "~/")
		  (call-interactively 'self-insert-command))))))

(provide 'setup-ido)
