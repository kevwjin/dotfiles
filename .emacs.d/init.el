(require 'package)

; Melpa as default emacs package repository
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
; activate packages
(package-initialize)

(setq evil-want-C-u-scroll t)
(require 'evil)
(evil-mode 1)

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;; list behavior like in Google Docs
(add-hook 'org-mode-hook (lambda () (org-autolist-mode)))

;; word wrap and indent
(add-hook 'org-mode-hook #'(lambda () (visual-line-mode) (org-indent-mode)))
;; (setq org-adapt-indentation nil)
;; (setq org-src-preserve-indentation nil 
;; org-edit-src-content-indentation 0)
;; (setq org-edit-src-content-indentation 0
;;       org-src-tab-acts-natively t
;;       org-src-preserve-indentation t)
(setq org-src-fontify-natively t
      org-src-window-setup 'current-window
      org-src-strip-leading-and-trailing-blank-lines t
      org-src-preserve-indentation t
      org-src-tab-acts-natively t)

;; permanently set tab width to 4 spaces
(setq-default indent-tabs-mode nil)
(setq tab-width 4)

;; expands snippets (e.g. code block)
(require 'org-tempo)

(define-key text-mode-map (kbd "TAB") 'self-insert-command);

;; evil-org: provides better vim bindings
(use-package evil-org
  :commands evil-org-mode
  :after org
  :init
  (add-hook 'org-mode-hook 'evil-org-mode)
  :config
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading)))))

;; color scheme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; (load-theme 'base16-papercolor-light-light t)
;; (load-theme 'twilight-bright t)
;; (load-theme 'cloud t)

(require 'apropospriate)
(load-theme 'apropospriate-light t)

;; (set-face-attribute 'fringe nil :background nil)
;; (set-face-background 'mode-line "#f3f3f3")
;; (set-face-background 'mode-line-inactive "#f3f3f3")

;; remove tool bar and scroll bar
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; remove bell sound
(setq ring-bell-function (lambda ()))

;; relative line numbers
(menu-bar-display-line-numbers-mode 'relative)
(add-hook 'foo-mode-hook #'display-line-numbers-mode)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("76b4632612953d1a8976d983c4fdf5c3af92d216e2f87ce2b0726a1f37606158" "0cb3fb0a9af57618f38b61e61057b05f58a5bafc655e22dee1356e79d331b3c1" "0f11d0be0d81c7cd3f5fe4d8c01e32e53b83eea3aa33b0bf574aff0abb6cebc2" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
