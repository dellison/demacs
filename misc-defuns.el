
(defun de/put-current-buffer-next-to (buf)
  "Put the current buffer in a window, and switch to BUF
in the current window."
  (interactive "B")
  (switch-to-buffer-other-window (current-buffer))
  (switch-to-buffer-other-window buf))

(defun de/indent-to ()
  "Insert a newline and indent to something.
RET means current position.
Anything else means that previous occurance of that character."
  (interactive)
  (let ((key (read-key "Indent to (RET for current position): ")))
    (if (equal key 13) ;; 13 is RET
	(let ((c (current-column)))
	  (newline)
	  (insert (make-string c 32)))
      ;; indent to a character
      (let* ((ch (make-string 1 key))
	     (next-pos (save-excursion
			 (search-backward ch)
			 (current-column))))
	(newline)
	(insert (make-string next-pos 32))))))

(defun de/newline-and-indent-to-here ()
  "Insert a newline at point, and then indent to the same position."
  (interactive)
  (let ((c (current-column)))
    (newline)
    (insert (make-string c 32))))

(defun toggle-window-split ()
  "Toggle between a horizontal and vertical arrangement of two windows.
Only works if there are exactly two windows active."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))
    (message "You must have two windows to toggle them!")))
(global-set-key (kbd "C-x |") 'toggle-window-split)

(defun swap-windows ()
  "If you have 2 windows, it swaps them. (from Steve Yegge)"
  (interactive)
  (cond ((not (= (count-windows) 2))(message "You need exactly 2 windows to do this."))
	(t
	 (let* ((w1 (nth 0 (window-list)))
		(w2 (nth 1 (window-list)))
		(b1 (window-buffer w1))
		(b2 (window-buffer w2))
		(s1 (window-start w1))
		(s2 (window-start w2)))
	   (set-window-buffer w1 b2)
	   (set-window-buffer w2 b1)
	   (set-window-start w1 s2)
	   (set-window-start w2 s1)))))

(defun de/indent-to-something-on-prev-line (s)
  "this lets you indent the current line as far as some
character on the previous line.
I wrote it thinking it would help write AVMs faster
in LaTeX."
  (interactive "sIntent to: ")
  (let* ((prev-line-anchor (save-excursion (forward-line -1)
					   (beginning-of-line)
					   (point)))
	 (prev-line-goal (save-excursion (forward-line -1)
					 (beginning-of-line)
					 (search-forward s)
					 (point)))
	 (to-indent (- prev-line-goal prev-line-anchor)))
    (beginning-of-line)
    (insert-char ?\s (- 1 to-indent))))
