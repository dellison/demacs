(setq ediff-split-window-function 'split-window-horizontally
      ediff-window-setup-function 'ediff-setup-windows-plain)

;; Restore old window configuration after running ediff
;; (appropriated from http://emacswiki.org/emacs/EdiffMode)
(defvar de/ediff-bwin-config nil
  "Window configuration before ediff.")

(defcustom de/ediff-bwin-reg ?b
  "*Register to be set up to hold `de/ediff-bwin-config'
    configuration.")

(defvar de/ediff-awin-config nil "Window configuration after ediff.")

(defcustom de/ediff-awin-reg ?e
  "*Register to be used to hold `de/ediff-awin-config' window
    configuration.")

(defun de/ediff-bsh ()
  "Function to be called before any buffers or window setup for
    ediff."
  (setq de/ediff-bwin-config (current-window-configuration))
  (when (characterp de/ediff-bwin-reg)
    (set-register de/ediff-bwin-reg
		  (list de/ediff-bwin-config (point-marker)))))

(defun de/ediff-ash ()
  "Function to be called after buffers and window setup for ediff."
  (setq de/ediff-awin-config (current-window-configuration))
  (when (characterp de/ediff-awin-reg)
    (set-register de/ediff-awin-reg
		  (list de/ediff-awin-config (point-marker)))))

(defun de/ediff-qh ()
  "Function to be called when ediff quits."
  (when de/ediff-bwin-config
    (set-window-configuration de/ediff-bwin-config)))

(add-hook 'ediff-before-setup-hook 'de/ediff-bsh)
(add-hook 'ediff-after-setup-windows-hook 'de/ediff-ash 'append)
(add-hook 'ediff-quit-hook 'de/ediff-qh)

(defun de/ediff-these-two-buffers ()
  "If you have two buffers, ediff them."
  (interactive)
  (if (not (= (count-windows) 2))
      (message "You need exactly two windows to do this.")
    (let* ((w1 (nth 0 (window-list)))
	   (w2 (nth 1 (window-list)))
	   (b1 (window-buffer w1))
	   (b2 (window-buffer w2)))
      (ediff-buffers b1 b2))))

(provide 'setup-ediff)
