(require 'eww)

(evil-set-initial-state 'eww-mode 'emacs)

(defun de/eww-open-this-dwim ()
  (interactive)
  (cond
   ((region-active-p)
    (let ((beg (region-beginning))
	  (end (region-end)))
      (eww (buffer-substring beg end))))
   ((and (fboundp 'markdown-link-p) (markdown-link-p))
    (eww (markdown-link-link)))
   (t
    (message "something else?"))))

(defun de/eww-mode-hook ()
  "setup for EWW, the emacs web browser (wowser)"
  (local-set-key [f12] 'eww-browse-with-external-browser)
  ;;; these don't seem to work yet...
  (define-key eww-mode-map [f12] 'eww-browse-with-external-browser)
  (define-key eww-mode-map [f12] 'eww-browse-with-external-browser))

(add-hook 'eww-mode-hook 'de/eww-mode-hook)

(provide 'setup-eww)
