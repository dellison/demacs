(require 'term)

(face-remap-add-relative 'term
			 '((:background "#000000" :foreground "#FFFFFF")))

(setq ansi-term-color-vector
      [unspecified "#000000" "#963F3C" "#5FFB65" "#FFFD65" 
                   "#0082FF" "#FF2180" "#57DCDB" "#FFFFFF"])

(define-key term-raw-map (kbd "M-o") #'other-window)

(provide 'setup-term)
