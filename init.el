(defvar demacs-directory
  "s:/demacs"
  "directory with emacs customization files")

(add-to-list 'load-path demacs-directory)

(defun de/log (m)
  "print a log message with a timestamp, and message m"
  (message "%s\t%s" (format-time-string "%F,%T:%3N") m))

(de/log "initializing package stuff.")
(when (fboundp 'list-packages)
  (require 'package)
  (setq package-user-dir (format "%s/elpa" demacs-directory))
  (setq package-archives
	'(("org" . "http://orgmode.org/elpa/")
	  ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
	  ("melpa" . "http://melpa.milkbox.net/packages/")
	  ("gnu" . "http://elpa.gnu.org/packages/")))
  (package-refresh-contents)
  (defun install-if-needed (package)
    "I hope to deprecate this soon in favor of `use-package' -de"
    (unless (package-installed-p package)
      (package-install package)))
  (package-initialize))

(de/log "starting server")
(when (display-graphic-p)
  (server-start))

(when (eq system-type 'darwin)
  (de/log "setting up OSX")
  (require 'setup-osx))

(when (eq system-type 'windows-nt)
  (de/log "setting up windows")
  (require 'setup-windows))

(de/log "setting up core (preferences, keybindings, etc...")
(require 'setup-core)
(de/log "setting up evil")
(require 'setup-evil) ;; load evil first

(de/log "setting up keybindings")
(require 'setup-keybindings)
(de/log "running setup-dired")
(require 'setup-dired)
(de/log "running setup-shell")
(require 'setup-shell)
(de/log "running setup-ediff")
(require 'setup-ediff)
(de/log "running setup-eshell")
(require 'setup-eshell)

(de/log "running setup-helm")
(require 'setup-helm)

(de/log "running setup-yasnippet")
(require 'setup-yasnippet)
(de/log "running setup-projectile")
(require 'setup-projectile)

(de/log "setup-running mode-line")
(require 'setup-mode-line)
;; (require 'setup-compile)
(de/log "running setup-org")
(require 'setup-org)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; language specific things ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(de/log "running setup-lisps")
(require 'setup-lisps) ; general stuff for elisp/clojure/...
(de/log "running setup-clojure")
(require 'setup-clojure)
(de/log "running setup-common-lisp")
(require 'setup-common-lisp)
(de/log "running setup-elisp")
(require 'setup-elisp)
(de/log "running setup-haskell")
(require 'setup-haskell)
(de/log "running setup-javascript")
(require 'setup-javascript)
(de/log "running setup-latex")
(require 'setup-latex)
(de/log "running setup-ruby")
(require 'setup-ruby)
(de/log "running setup-perl")
(require 'setup-perl)
(de/log "running setup-prolog")
(require 'setup-prolog)
(de/log "running setup-python")
(require 'setup-python)
(de/log "running setup-scheme")
(require 'setup-scheme)
(de/log "running setup-web")
(require 'setup-web)

(de/log "running setup-eww")
(require 'setup-eww)

(when (file-exists-p (format "%s/setup-site.el" demacs-directory))
  (de/log "running setup-site")
  (require 'setup-site))

(message de/scratch-yeah)
