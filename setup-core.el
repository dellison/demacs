;; no menu bar (on GUI OSX it's okay since it's not part of the emacs frame)
(if (and (fboundp 'menu-bar-mode) (not (eq system-type 'darwin)))
    (menu-bar-mode -1))

;; no toolbar either
(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))

;; no scrollbar (nyan-mode instead)
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

(setq inhibit-startup-message t
      visible-bell t             
      scroll-conservatively 1
      scroll-error-top-bottom t
      enable-recursive-minibuffers t
      echo-keystrokes 0.1
      backup-directory-alist '(("." . "~/backups"))
      gc-cons-threshold 20000000)


(show-paren-mode 1)

(when (display-graphic-p)
  (blink-cursor-mode 0)
  (global-hl-line-mode 1)
  (set-face-attribute 'hl-line nil :background "#3C3C3C")
  (global-hl-line-mode t))



(winner-mode 1)

;; if you're looking at a file, the frame title should be the full path
(setq frame-title-format
      '(:eval (or buffer-file-name (buffer-name))))

(set-default 'indicate-unused-lines t)

(defalias 'remove-lines 'flush-lines)
(defalias 'qrr 'query-replace-regexp)
(defalias 'yes-or-no-p 'y-or-n-p)
(defalias 'wc 'count-words)

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

;;
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

(require 'comint)
(defun de/clear-comint-buffer ()
  "Clear the comint buffer"
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))

(define-key comint-mode-map (kbd "C-c M-o") 'de/clear-comint-buffer)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;;; use utf-8 everywhere!
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(define-coding-system-alias 'utf8 'utf-8)
;; backwards compatibility as default-buffer-file-coding-system
;; is deprecated in 23.2.
(if (boundp 'buffer-file-coding-system)
    (setq-default buffer-file-coding-system 'utf-8)
  (setq default-buffer-file-coding-system 'utf-8))

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;;; enable all the disabled commands
(mapatoms (lambda (s) (when (get s 'disabled) (put s 'disabled nil))))

(use-package ibuffer
  :commands ibuffer
  :bind
  (("C-x C-b" . ibuffer)
   :map ibuffer-mode-map
   ("/ u" . ibuffer-filter-by-unsaved)
   ("M-o" . other-window)
   ("j" . ibuffer-forward-line)
   ("k" . ibuffer-backward-line)
   ("J" . ibuffer-jump-to-buffer)
   ("K" . ibuffer-do-kill-lines)
   ("U" . ibuffer-unmark-all)
   ("M-<" . de/ibuffer-beginning-of-buffer)
   ("M->" . de/ibuffer-end-of-buffer))
  :config
  (defun de/ibuffer-beginning-of-buffer ()
    (interactive)
    (beginning-of-buffer)
    (ibuffer-forward-line 2))
  (defun de/ibuffer-end-of-buffer ()
    (interactive)
    (end-of-buffer)
    (ibuffer-backward-line))
  (defun de/setup-ibuffer-filters ()
    ;; add an "unsaved" filter
    (define-ibuffer-filter unsaved
	"Toggle current view to only buffers which are unsaved."
      (:description "unsaved")
      (with-current-buffer buf
	(and buffer-file-name (buffer-modified-p)))))
  (add-hook 'ibuffer-hook #'de/setup-ibuffer-filters))

(require 'setup-isearch)

(unless (package-installed-p 'use-package)
  (unless (assoc 'package package-archive-contents)
    ;; (package-refresh-contents)
    (package-install 'use-package)))
(require 'use-package)

;; never have the menu bar when running in a terminal
(if (not (display-graphic-p))
    (menu-bar-mode -1))

(when (display-graphic-p)
  (defun toggle-fullscreen ()
    "Toggle full screen"
    (interactive)
    (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

  (whitespace-mode 1)
  (use-package zenburn-theme
    ;; :disabled
    :ensure zenburn-theme

    :config
    (mapc (lambda (face)
  	    (set-face-attribute face nil
  				:foreground "#4F4F4F"
  				:background "#3F3F3F"))
  	  '(whitespace-tab
  	    whitespace-space
  	    whitespace-newline))
    (set-face-attribute 'whitespace-line nil
    			:foreground nil
    			:background nil)
    (set-face-attribute 'whitespace-empty nil
			:foreground "#545444"
			:background "#4F4F4F")
    (set-face-attribute 'whitespace-trailing nil
    			:foreground "#545444"
    			:background "#4F4F4F")))

(use-package beacon
  :ensure beacon
  :config
  (setq beacon-color "#888888"
	beacon-blink-duration 0.2
	beacon-blink-when-focused t
	beacon-size 12)
  (beacon-mode 1))

(use-package aggressive-indent
  :ensure aggressive-indent)

;; (use-package smartparens
;;   :ensure smartparens)

;;; a few smaller packages from ELPA
(use-package yasnippet
  :ensure yasnippet
  :config
  (add-to-list 'yas/snippet-dirs (format "%s/snippets" demacs-directory)))

(use-package highlight-symbol
  :ensure highlight-symbol
  :config
  (progn
    (setq highlight-symbol-idle-delay 2.0)
    (set-face-attribute 'highlight-symbol-face nil
			:background "#5F5F5F"
			;; :foreground "#DC8CC3"
			)
    (highlight-symbol-mode 1))) ;; don't use it :(

;; vc-mode for svn
(require 'vc)
(require 'vc-dir)
(define-key vc-dir-mode-map "e" #'vc-ediff)

(defun de/vc-dir-here ()
  ""
  (interactive)
  (if default-directory
      (vc-dir default-directory)
    (vc-dir)))

(global-set-key (kbd "C-c v d") #'de/vc-dir-here)
;; use Magit for git stuff
(use-package magit
  :ensure t

  :bind (("C-c g s" . magit-status)
	 (:map magit-mode-map
	  ("e" . magit-ediff)
	  ("E" . magit-ediff-dwim)))
  
  :config
  )
(use-package forge
  :ensure t
  :init (setq eieio-backward-compatibility nil))

(use-package multiple-cursors
  :ensure multiple-cursors
  :bind (("M-+" . mc/mark-next-like-this)))

(use-package expand-region
  :ensure expand-region
  :bind (("C-M-=" . er/expand-region)))

(use-package dash
  :ensure dash)

(use-package undo-tree
  :ensure undo-tree
  :bind (("C-x u" . undo-tree-visualize)))

(use-package company
  :ensure company)

(provide 'setup-core)
