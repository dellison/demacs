;; no GUI
(if (and (fboundp 'menu-bar-mode) (not (eq system-type 'darwin))) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(setq inhibit-startup-message t
      visible-bell t             
      blink-cursor-mode -1
      scroll-conservatively 1
      scroll-error-top-bottom t
      enable-recursive-minibuffers t
      echo-keystrokes 0.1
      backup-directory-alist '(("." . "~/backups"))
      gc-cons-threshold 20000000)

(show-paren-mode 1)
(winner-mode 1)

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

(defun de/indent-to-something-on-prev-line (s)
  "boy oh boy this one is ugly...
this lets you indent the current line as far as some
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

(require 'uniquify)
;; no more 'post-forward-angle-brackets
(setq uniquify-buffer-name-style 'forward)

;;; use utf-8 everywhere!
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; backwards compatibility as default-buffer-file-coding-system
;; is deprecated in 23.2.
(if (boundp 'buffer-file-coding-system)
    (setq-default buffer-file-coding-system 'utf-8)
  (setq default-buffer-file-coding-system 'utf-8))
 
;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;;; enable all the disabled commands
(mapatoms (lambda (s) (when (get s 'disabled) (put s 'disabled nil))))

;;; use ibuffer instead of list-buffers
(global-set-key (kbd "C-x C-b") 'ibuffer)
(add-hook 'ibuffer-mode-hook
	  (defun de/ibuffer-mode-hook ()
	    (local-set-key (kbd "U") 'ibuffer-unmark-all)
	    (local-set-key (kbd "C-x C-f") 'ido-find-file)
	    (message "setting up ibuffer!")))

;;; package setup
;; (add-to-list 'package-archives '("melpa" . "http://stable.melpa.org/packages/"))
(setq package-archives '(("org" . "http://orgmode.org/elpa/")
			 ;; ("melpa-stable" . "http://stable.melpa.org/packages/")
			 ("melpa" . "http://melpa.org/packages/")
			 ("gnu" . "http://elpa.gnu.org/packages/")))
(defun install-if-needed (package)
  "I hope to deprecate this soon in favor of `use-package' -de"
  (unless (package-installed-p package)
    (package-install package)))

(setq package-enable-at-startup nil)
(unless (package-installed-p 'use-package)
  (unless (assoc 'package package-archive-contents)
    (package-refresh-contents)
    (package-install 'use-package)))
(require 'use-package)

(when (display-graphic-p)
  (defun toggle-fullscreen ()
    "Toggle full screen"
    (interactive)
    (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))
  (use-package zenburn-theme
    :ensure zenburn-theme
    :config
    (progn
      ;; try to fix whitespace highlighting
      
      ))
  ;; (use-package solarized-theme
  ;;   :ensure solarized-theme
  ;;   :config
  ;;   (progn
  ;;     (load-theme 'solarized-dark))
  ;;   )
  (global-hl-line-mode 1))

;;; now setup a few smaller packages from ELPA
(use-package yasnippet
  :ensure yasnippet
  :init (add-to-list 'yas/snippet-dirs (format "%s/snippets" demacs-directory)))

;; a little mode line setup
(use-package diminish
  :ensure diminish)
(display-time-mode 1)
(column-number-mode 1)

(use-package highlight-symbol
  :ensure highlight-symbol
  :init (progn
	  (setq highlight-symbol-idle-delay 2.5)
	  (set-face-attribute 'highlight-symbol-face nil
			      ;; :background "#93E0E3"
			      ;; :foreground "#DC8CC3"
			      )
	  (highlight-symbol-mode -1))) ;; don't use it :(

;; use Magit for git stuff
(use-package magit
  :ensure magit
  :init (progn
	  (global-set-key (kbd "C-c gs") 'magit-status)
	  (when (eq system-type 'darwin)
	    (setq magit-emacsclient-executable "/usr/local/Cellar/emacs/24.3/bin/emacsclient"))))

(use-package multiple-cursors
  :ensure multiple-cursors
  :bind (("M-+" . mc/mark-next-like-this)))

(use-package expand-region
  :ensure expand-region
  :bind (("C-M-=" . er/expand-region)))

(use-package ace-jump-mode
  :ensure ace-jump-mode
  :bind (("C-c SPC" . ace-jump-mode)))

(use-package dash
  :ensure dash)

(use-package undo-tree
  :ensure undo-tree
  :bind (("C-x u" . undo-tree-visualize)))

(use-package company
  :ensure company)

;; smartparens?

(provide 'setup-core)
