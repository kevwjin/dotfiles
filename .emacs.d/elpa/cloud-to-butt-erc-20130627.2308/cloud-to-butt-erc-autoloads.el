;;; cloud-to-butt-erc-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "cloud-to-butt-erc" "cloud-to-butt-erc.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from cloud-to-butt-erc.el

(autoload 'cloud-to-butt-in-buffer "cloud-to-butt-erc" nil nil nil)

(when (and (boundp 'erc-modules) (not (member 'cloud-to-butt 'erc-modules))) (add-to-list 'erc-modules 'cloud-to-butt))

(eval-after-load 'erc '(progn (unless (featurep 'cloud-to-butt-erc) (require 'cloud-to-butt-erc)) (add-to-list 'erc-modules 'cloud-to-butt t)))

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "cloud-to-butt-erc" '("cloud-to-butt-replacement-decoration")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; cloud-to-butt-erc-autoloads.el ends here
