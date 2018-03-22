
;; add cygwin things to path
;; (always prefer cygwin tools to windows ones if there's a collision)
(setenv "PATH" (concat "c:\\cygwin\\bin;"
		       "c:\\cygwin\\usr\\bin;"
		       (getenv "PATH")))

(setq shell-file-name "c:/cygwin/bin/bash.exe")
(add-to-list 'exec-path "c:/cygwin/bin;")

;;; use Git Bash (and other tools provided there) instead
(setenv "HOME" "c:/Users/davide")
(setenv "PATH" (concat "c:/Program Files/Git/bin;" (getenv "PATH")))
(add-to-list 'exec-path "c:/Program Files/Git/bin")
;; (setenv "GIT_ASKPASS" "git-gui--askpass") ;; so that pushing from Magit can work

(setq with-editor-emacsclient-executable "s:/emacs/bin/emacsclientw.exe")

;; cygwin shells aren't working right now :(
(defun cygwin-shell ()
  "Run cygwin bash in shell mode"
  (interactive)
  (let ((explicit-shell-file-name "C:/cygwin/bin/bash"))
    (call-interactively 'shell)))

(require 'server)
(when (and (>= emacs-major-version 23)
           (equal window-system 'w32))
  (defun server-ensure-safe-dir (dir) "Noop" t)) ; Suppress error "directory
                                                 ; ~/.emacs.d/server is unsafe"
                                                 ; on windows.
(server-start)


;; open things in windows explorer window
(defun explorer ()
  "Launch the windows explorer in the current directory and selects current file"
  (interactive)
  (message (convert-standard-filename buffer-file-name))
  (w32-shell-execute
   "open"
   "explorer"
   (concat "/e,/select,"
	   (substring (shell-command-to-string
		       (concat "cygpath -wa "
			       (replace-regexp-in-string " " "\\\\ "
							 (convert-standard-filename buffer-file-name))))
		      0 -1))))
(global-set-key [f12] 'explorer)

(defun dired-explorer ()
  "launch the windows explorer in the current directory"
  (interactive)
  (message (substring (shell-command-to-string (concat "cygpath -wa " dired-directory)) 0 -1))
  (w32-shell-execute
   "open"
   "explorer"
   (substring (shell-command-to-string (concat "cygpath -wa " (replace-regexp-in-string " " "\\\\ " dired-directory))) 0 -1)))

(add-hook 'dired-mode-hook (lambda () (local-set-key [f12] 'dired-explorer)))

;; get rid of that annoying ^M in files with mixed line endings
(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

;; shell setup from

(defun my-shell-setup ()
  "For Cygwin bash under Emacs 20"
  (setq comint-scroll-show-maximum-output 'this)
  (make-variable-buffer-local 'comint-completion-addsuffix))
(setq comint-completion-addsuffix t)
;; (setq comint-process-echoes t) ;; reported that this is no longer needed
(setq comint-eol-on-send t)
(setq w32-quote-process-args ?\")

(setq shell-mode-hook 'my-shell-setup)


;;; python/anaconda setup on windows
(let ((conda-exe "c:/Users/davide/Anaconda2/python.exe"))
  (if (file-exists-p conda-exe)
      (setq python-shell-interpreter conda-exe)))


(provide 'setup-windows)
