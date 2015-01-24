(defvar demacs-directory
  "~/demacs"
  "directory with emacs customization files")

(add-to-list 'load-path demacs-directory)

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
(require 'setup-ediff)
(require 'eshell)
(require 'setup-ido)

(require 'setup-yasnippet)
(require 'setup-projectile)

(require 'setup-mode-line)
;; (require 'setup-compile)
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
(require 'setup-latex)
(require 'setup-ruby)
(require 'setup-perl)
(require 'setup-prolog)
;; (require 'setup-python)
(require 'setup-elpy)

(if (file-exists-p (format "%s/setup-site.el" demacs-directory))
    (require 'setup-site))

