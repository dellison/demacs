(setq de-ruby-packages '(inf-ruby))

(mapc 'install-if-needed de-ruby-packages)

(require 'inf-ruby)

(defalias 'irb 'run-ruby)

(provide 'setup-ruby)
