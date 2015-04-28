;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;; Sets up a custom mode line
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (fboundp 'csv-mode)
  (message "trying to set up the mode line with csv mode"
	   ;; TODO
	   ))

(defun mode-line-fill (face reserve)
  "Return empty space using FACE and leaving RESERVE space on the right."
  (unless reserve
    (setq reserve 20))
  (when (and window-system (eq 'right (get-scroll-bar-mode)))
    (setq reserve (- reserve 3)))
  (propertize " "
              'display `((space :align-to (- (+ right right-fringe right-margin) ,reserve)))
              'face face))

(use-package nyan-mode
  :ensure nyan-mode
  :config
  (progn
    (setq nyan-bar-length 18
	  nyan-wavy-trail nil)))


(defvar de/mode-line-evil
  '(:eval
    (let ((evil-modeline-indicator-color ;; not actually using this right now...
	   (case evil-state
	     ('emacs  (setq evil-modeline-indicator-color "#CC99FF"))
	     ('normal (setq evil-modeline-indicator-color "#DFAF8F"))
	     ('visual (setq evil-modeline-indicator-color "#3399FF")))))
      ;; (propertize evil-mode-line-tag
      ;; 		  'face 'font-lock-variable-name-face)
      evil-mode-line-tag
      ))
  "Display the evil state in the mode line")

(defvar de/mode-line-buffer-name
  '(:eval
    (concat 
     ;; (if (and (not (eq major-mode 'dired-mode)) buffer-file-name)
     ;; 	 (propertize default-directory
     ;; 		     'face '(:height 130)))
     (propertize "%b" 
		 'face 'font-lock-keyword-face)
     (propertize (concat "" (if (and (buffer-file-name) (buffer-modified-p)) "[*]" "   "))
     		 'face '(:height 130))))
  "Display the buffer name, with trailing \"[*]\" if modified from disk.")

(defvar de/mode-line-buffer-size
  '(:eval (concat (propertize "[ %l | %c ] "
			      'face '(:height 130))))
  "Display the line number")

(defvar de/mode-line-mode-info
  '(:eval (propertize "%m"
		      'face 'font-lock-variable-name-face))
  "Display the major mode")

(setq de/mode-line-time
      '(:eval
	(propertize (format-time-string "   %a, %m/%d %I:%M%p")
		    'face '(:height 130 :foreground "LightSkyBlue"))))

(setq-default mode-line-format
	      (list ""
		    de/mode-line-evil
		    "%@ " ;; '-' if `default-directory' is local, '@' if it's remote
		    de/mode-line-buffer-name
		    de/mode-line-buffer-size
		    ;; mode-line-position
		    '(:eval (nyan-create))
		    de/mode-line-mode-info " "
		    de/mode-line-time))

(provide 'setup-mode-line)
