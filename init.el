(if (eq system-type 'darwin)
    (defvar user-emacs-directory "~/demacs"
      "Directory containing all my emacs customizations."))
(if (eq system-type 'windows-nt)
    (defvar user-emacs-directory "c:/Users/davide/demacs"
      "Directory containing all my emacs customizations."))
(if (eq system-type 'cygwin)
    (defvar user-emacs-directory "/cygdrive/c//Users/davide/demacs"
      "Directory containing all my emacs customizations."))

(add-to-list 'load-path "~/demacs")

(when (fboundp 'list-packages)
  (require 'setup-packages))

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

(require 'setup-evil) ; load evil first

(require 'setup-preferences)
(load "defuns.el")
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
