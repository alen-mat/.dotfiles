;;http://pages.sachachua.com/.emacs.d/Sacha.html
;;https://www.reddit.com/r/emacs/comments/3q50do/best_way_organization_config_files_in_the_emacs/
;;https://github.com/tonini/emacs.d/blob/master/init.el

(setq message-log-max 10000)

(setq load-prefer-newer t)

(fset 'yes-or-no-p 'y-or-n-p)

(setq backup-directory-alist '(("." . "~/.config/emacs/backups")))

(defvar my/laptop-p (equal (system-name) "alen-8918"))
(defvar my/server-p (and (equal (system-name) "localhost") (equal user-login-name "alen.m")))
(defvar my/phone-p (not (null (getenv "ANDROID_ROOT")))
  "If non-nil, GNU Emacs is running on Termux.")
(when my/phone-p (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))
(global-auto-revert-mode)  ; simplifies syncing

(setq user-full-name ""
      user-mail-address "@")

(require 'server)
(unless (server-running-p)
  (server-start))

(setq emacs-custom-config-dir  (concat (file-name-as-directory user-emacs-directory) "config"))
(setq file-mode-config-dir  (concat (file-name-as-directory emacs-custom-config-dir) "modes"))

(add-to-list 'load-path (expand-file-name emacs-custom-config-dir))
(require 'ui)
(require 'key-binding)
(require 'install-pkg)
(require 'utils)

(add-to-list 'load-path (expand-file-name file-mode-config-dir))
(require 'org-config)
(require 'cc-config)
;;(add-to-list 'load-path "~/.emacs.d/config/")
;;Loading custom file
;;(setq custom-file "~/.emacs.d/custom.el")
;;(ignore-errors (load custom-file))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(org-bullets markdown-mode which-key use-package org-plus-contrib exec-path-from-shell evil doom-modeline auto-package-update)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
