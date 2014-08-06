;; no GUI
(if (and (fboundp 'menu-bar-mode) (not (eq system-type 'darwin))) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(setq inhibit-startup-message t  ;; no splash screen
      visible-bell t             ;; blink, don't beep
      blink-cursor-mdoe -1       ;; but not the cursor
      scroll-conservatively 1    ;; scroll like VIM
      enable-recursive-minibuffers t
      echo-keystrokes 0.1
      ediff-split-window-function 'split-window-horizontally
      )

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
	  (if this-win-2nd (other-window 1)))))
  (message "You must have two windows to toggle them!"))
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

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;; package setup
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
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
  (use-package zenburn-theme :ensure zenburn-theme)
  (global-hl-line-mode 1))

(use-package idle-highlight-mode
  :ensure idle-highlight-mode
  :init (setq idle-highlight-idle-time 2.0))

;;; enable all the disabled commands
(mapatoms (lambda (s) (when (get s 'disabled) (put s 'disabled nil))))

;;; now setup a few smaller packages
(use-package yasnippet
  :ensure yasnippet)

;; a little mode line setup
(use-package diminish
  :ensure diminish)
(display-time-mode 1)
(column-number-mode 1)

;; use Magit for git stuff
(use-package magit
  :ensure magit
  :init (when (eq system-type 'darwin)
	  (setq magit-emacsclient-executable "/usr/local/Cellar/emacs/24.3/bin/emacsclient")))

(use-package multiple-cursors
  :ensure multiple-cursors
  :bind (("M-+" . mc/mark-all-dwim)))

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

;; smartparens?

(provide 'setup-core)
