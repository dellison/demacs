
(defun de:filter (condp lst)
  "Filter function. Apply condp to each item in lst,
return resulting list."
  (delq nil
	(mapcar (lambda (x) (and (funcall condp x) x)) lst)))


(defun swap-windows ()
 "If you have 2 windows, it swaps them. (from Steve Yegge)"
 (interactive)
 (cond ((not (= (count-windows) 2))(message "You need exactly 2 windows to do this."))
       (t
	(let* ((w1 (first (window-list)))
	       (w2 (second (window-list)))
	       (b1 (window-buffer w1))
	       (b2 (window-buffer w2))
	       (s1 (window-start w1))
	       (s2 (window-start w2)))
	  (set-window-buffer w1 b2)
	  (set-window-buffer w2 b1)
	  (set-window-start w1 s2)
	  (set-window-start w2 s1)))))
(global-set-key (kbd "C-c sw") 'swap-windows)

(defun google-search (query)
  "Search google for `query in default browser."
  (interactive "sGoogle: ")
  (browse-url (format "https://www.google.com/#q=%s" query)))
(global-set-key (kbd "C-c go") 'google-search)
