(require 'cperl-mode)
(add-to-list 'auto-mode-alist '("\\.pl\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.pm\\'" . cperl-mode))

(add-hook 'cperl-mode-hook 
	  (defun de/perl-mode-hook ()
	    (setq cperl-hairy t))
	  (autopair-mode -1)
	  )

(provide 'setup-perl)
