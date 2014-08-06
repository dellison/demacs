(require 'info)



(let ((my-info-dir "~/demacs/info"))
  (setenv "INFOPATH" (concat (getenv "INFOPATH")
			     (concat my-info-dir ":")))
  (message (getenv "INFOPATH")))
  

;; (add-hook 'Info-mode-hook
;; 	  (defun de/add-extra-info ()
;; 	    (add-to-list Info-additional-directory-list "demacs/info")))

(setq de/info-directories '("~/demacs/info"
			    "/usr/share/info") )

(add-hook 'Info-mode-hook
	  (defun de/Info-mode-hook ()
	    (define-key evil-motion-state-local-map (kbd "S-SPC") 'Info-scroll-up)))

(defun de/open-info-file ()
  "Opens info file"
  (interactive)
  (info
   (ido-completing-read "Info file: "
			(de:filter
			 (lambda (x)
			   (string-match "\\.info$" x))
			 (mapcar (lambda (x)
				   (replace-regexp-in-string "\\.gz" "" x))
				 (file-expand-wildcards "~/demacs/info/*"))))))

(provide 'setup-info)
