

(use-package tablist
  :ensure t)

(use-package pdf-tools
  :ensure t

  :mode (("\\.pdf\\'" . pdf-view-mode))

  :bind ((:map pdf-view-mode-map
	       ("h" . image-backward-hscroll)
	       ("j" . pdf-view-next-line-or-next-page)
	       ("J" . de/pdf-faster-next-line-or-page)
	       ("k" . pdf-view-previous-line-or-previous-page)
	       ("K" . de/pdf-faster-previous-line-or-page)
	       ("l" . image-forward-hscroll)
	       ("o" . pdf-outline))
	 (:map pdf-outline-minor-mode-map
	       ("a" . outline-show-all)))

  :config
  (pdf-tools-install)
  (defun de/pdf-faster-next-line-or-page (&optional lines)
    (interactive)
    (pdf-view-next-line-or-next-page (or lines 10)))
  (defun de/pdf-faster-previous-line-or-page (&optional lines)
    (interactive)
    (pdf-view-previous-line-or-previous-page (or lines 10)))

  (defun de/pdf-view-mode-setup ()
    (pdf-isearch-minor-mode 1)
    (pdf-outline-minor-mode 1))
  (add-hook 'pdf-view-mode-hook #'de/pdf-view-mode-setup)

  (setq pdf-view-resize-factor 1.1)

  (require 'pdf-outline))

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
