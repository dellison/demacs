(use-package csv-mode
  :ensure t

  :config
  ;; this overrides a "defconst" but csv-mode
  ;; doesn't work with my special mode line otherwise
  (setq csv-mode-line-format mode-line-format)) 
