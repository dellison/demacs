(require 'package)

(setq package-user-dir "~/demacs/elpa")

;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

;; (setq package-archives '(("melpa-stable" . "http://melpa.milkbox.net/packages/")
;; 			 ;; ("marmalade" . "http://marmalade-repo.org/packages/")
;; 			 ))

(package-refresh-contents)

(defun install-if-needed (package)
  (unless (package-installed-p package)
    (package-install package)))

(package-initialize)

(setq package-enable-at-startup nil)
(unless (package-installed-p 'use-package)
  (unless (assoc 'package package-archive-contents)
    (package-refresh-contents)
    (package-install 'use-package)))
(require 'use-package)


(setq my-packages '(yasnippet
		    magit
		    zenburn-theme
		    expand-region
		    ;autopair
		    smartparens
		    multiple-cursors
		    ace-jump-mode
		    dash
		    undo-tree
		    ))

(mapc 'install-if-needed my-packages)

(when (display-graphic-p)
  (require 'zenburn-theme)
  )

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; (require 'autopair)
;; (autopair-global-mode t)
(require 'smartparens)
(show-smartparens-mode 1)
(show-smartparens-global-mode +1)
(show-paren-mode -1)

(require 'multiple-cursors)
(global-set-key (kbd "M-+") 'mc/mark-next-like-this)

(require 'ace-jump-mode)
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)

(require 'dash)

(provide 'setup-packages)

