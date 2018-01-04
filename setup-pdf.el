

(use-package tablist
  :ensure t)

(use-package pdf-tools
  :ensure pdf-tools

  :config
  (pdf-tools-install)
  (define-key pdf-view-mode-map "h" #'image-backward-hscroll)
  (define-key pdf-view-mode-map "j" #'pdf-view-next-line-or-next-page)
  (define-key pdf-view-mode-map "k" #'pdf-view-previous-line-or-previous-page)
  (define-key pdf-view-mode-map "l" #'image-forward-hscroll)

  (define-key pdf-view-mode-map "J" (lambda ()
				      (interactive)
				      (pdf-view-next-line-or-next-page 10)))
  (define-key pdf-view-mode-map "K" (lambda ()
                                      (interactive)
                                      (pdf-view-previous-line-or-previous-page 10)))
  (setq pdf-view-resize-factor 1.1)

  (require 'pdf-outline)
  (define-key pdf-outline-buffer-mode-map "j" #'next-line)
  (define-key pdf-outline-buffer-mode-map "k" #'previous-line))

(defun de/org-pdf-view-store-link ()
  (when (equal major-mode 'pdf-view-mode)
    (let* ((title "pdf")
	   (file (buffer-file-name))
	   (page (pdf-view-current-page))
	   (link (format "pdf-tools:%s::%d" file page)))
      (org-store-link-props
       ;; :type "pdf-view"
       :type "pdf-tools"
       :link link
       :description title)
      (format "[[%s][%s]]" link title))))

;;; this function is mostly stolen from org-docview.el
(defun de/org-pdf-view-open-link (link)
  (string-match "\\(.*?\\)\\(?:::\\([0-9]+\\)\\)?$" link)
  (let ((path (match-string 1 link))
	(page (and (match-beginning 2)
		   (string-to-number (match-string 2 link)))))
    ;; Let Org mode open the file (in-emacs = 1) to ensure
    ;; org-link-frame-setup is respected.
    (org-open-file path 1)
    (when page (pdf-view-goto-page page))))

(org-link-set-parameters "pdf-tools"
			 :follow #'de/org-pdf-view-open-link
			 :store #'de/org-pdf-view-store-link)
(add-hook 'org-store-link-functions 'de/org-pdf-view-store-link)

(provide 'setup-pdf)
