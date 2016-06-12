(require 'eww)

(evil-set-initial-state 'eww-mode 'emacs)

(defun eww-search ()
  (interactive)
  (let ((terms (read-from-minibuffer "Search Terms: ")))
    (eww-browse-url (concat eww-search-prefix terms))))

(defun de/eww-dwim ()
  "open link with EWW under point (if there's a link there),
otherwise prompt for search terms"
  (interactive)
  (cond
   ((region-active-p)
    (let ((beg (region-beginning))
	  (end (region-end)))
      (eww (buffer-substring beg end))))
   ((thing-at-point 'url)
    (eww-browse-url (thing-at-point 'url)))
   ((and (eq major-mode 'markdown-mode)
	 (fboundp 'markdown-link-p) (markdown-link-p))
    (eww (markdown-link-link)))
   ((eq major-mode 'org-mode)
    (let ((browse-url-browser-function 'eww-browse-url))
      (org-open-at-point)))
   (t
    (eww-search))))

(global-set-key (kbd "C-c eww") #'de/eww-dwim)

(defun de/eww-mode-hook ()
  "setup for EWW, the emacs web browser (wowser)"
  (local-set-key [f12] 'eww-browse-with-external-browser)
  ;;; these don't seem to work yet...
  (define-key eww-mode-map [f12] 'eww-browse-with-external-browser)
  (define-key eww-mode-map [f12] 'eww-browse-with-external-browser))

(add-hook 'eww-mode-hook 'de/eww-mode-hook)

(provide 'setup-eww)
