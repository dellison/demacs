(require 'ido)
(ido-mode t)

(setq de/ido-packages '(flx-ido
			ido-vertical-mode
			ido-ubiquitous
			))

(mapc 'install-if-needed de/ido-packages)

;(ido-everywhere t)
(setq ido-enable-flex-matching t)

(flx-ido-mode 1)
(require 'flx-ido)
;(setq ido-use-faces nil)

(ido-vertical-mode t)
(require 'ido-vertical-mode)

(ido-ubiquitous-mode t)
(require 'ido-ubiquitous)

(provide 'setup-ido)
