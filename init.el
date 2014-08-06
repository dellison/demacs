(if (eq system-type 'darwin)
    (defvar demacs-directory "~/demacs"
      "Directory containing all my emacs customizations."))
(if (eq system-type 'windows-nt)
    (defvar demacs-directory "c:/Users/davide/demacs"
      "Directory containing all my emacs customizations."))
(if (eq system-type 'cygwin)
    (defvar demacs-directory "/cygdrive/c//Users/davide/demacs"
      "Directory containing all my emacs customizations."))

(add-to-list 'load-path "~/demacs")

(when (fboundp 'list-packages)
;;   (require 'setup-packages))
  (require 'package)
  (setq package-user-dir (format "%s/elpa" demacs-directory))
  (add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/"))
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
  (package-refresh-contents)
  (defun install-if-needed (package)
  "I hope to deprecate this soon in favor of `use-package' -de"
  (unless (package-installed-p package)
    (package-install package)))
  (package-initialize))

(setq customization-file "~/demacs/custom.el")

;; (defvar emacs-root-dir "~/demacs"
;;   "Directory with all elisp code for custumization.")
;; (add-to-list 'load-path emacs-root-dir)
;; (add-to-list 'load-path (concat emacs-root-dir "/site-lisp"))

(when (display-graphic-p)
    (server-start))

(if (eq system-type 'darwin)
    (require 'setup-osx))

(if (eq system-type 'windows-nt)
    (require 'setup-windows))


(require 'setup-core)
(require 'setup-evil) ; load evil first

;; (require 'setup-preferences)
;; (load "defuns.el")
(require 'setup-keybindings)
(require 'setup-smex)
(require 'setup-dired)
(require 'setup-shell)
(require 'setup-ido)
(require 'setup-ibuffer)

(require 'setup-encoding) ;; utf-8 everywhere

(require 'setup-magit)
(require 'setup-yasnippet)
(require 'setup-projectile)

(require 'setup-compile)
(require 'setup-org)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; language specific things ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'setup-lisps) ; general stuff for elisp/clojure/...
(require 'setup-clojure)
(require 'setup-common-lisp)
(require 'setup-elisp)
(require 'setup-ess) ; for R
(require 'setup-haskell)
(require 'setup-javascript)
(require 'setup-ruby)
(require 'setup-perl)
(require 'setup-prolog)
;; (require 'setup-python)
(require 'setup-elpy)

;; school
(require 'setup-clms)
