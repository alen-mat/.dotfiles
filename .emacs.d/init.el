;;
(setq user-full-name    "hooo"
      user-mail-address "hooooooo")
;;(message-box ".emacs.d/init.el says hello")
;;For better or for worse
(setq enable-local-variables :safe)
;;
;;Load packages
(require 'package)
;;Repositories
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.org/packages/")))

;; Actually get “package” to work.
(package-initialize)
(package-refresh-contents)
;;Package Install
;;Bootstraping use package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(setq use-package-always-ensure t);; :ensure t ;; install the evil package if not installed
;; load evil
(use-package evil
  :init ;; tweak evil's configuration before loading it
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config ;; tweak evil after loading it
  (evil-mode))
  ;; example how to map a command in normal mode (called 'normal state' in evil)
  ;;(define-key evil-normal-state-map (kbd ", w") 'evil-window-vsplit))
(use-package auto-package-update
  :config
  ;; Delete residual old versions
  (setq auto-package-update-delete-old-versions t)
  ;; Do not bother me when updates have taken place.
  (setq auto-package-update-hide-results t)
  ;; Update installed packages at startup if there is an update pending.
  (auto-package-update-maybe))
;; Making it easier to discover Emacs key presses.
(use-package which-key
  :diminish
  :config (which-key-mode)
          (which-key-setup-side-window-bottom)
          (setq which-key-idle-delay 0.05))
;; Haskell's cool
;;(use-package haskell-mode :defer t)

;; Lisp libraries with Haskell-like naming.
(use-package dash)    ;; “A modern list library for Emacs”
(use-package s   )    ;; “The long lost Emacs string manipulation library”.

;; Let's use the “s” library.
(defvar my/personal-machine?
  (not (s-contains? "alen" (shell-command-to-string "uname -a")))
  "Is this my personal machine, or my work machine?")

;; Library for working with system files;
;; e.g., f-delete, f-mkdir, f-move, f-exists?, f-hidden?
;;(use-package f)
;;Direct building of emac packages from source
;;(use-package quelpa
;;  :defer 5
;;  :custom (quelpa-upgrade-p t "Always try to update packages")
;;  :config
;;  ;; Get ‘quelpa-use-package’ via ‘quelpa’
;;  (quelpa
;;   '(quelpa-use-package
;;     :fetcher git
;;     :url "https://github.com/quelpa/quelpa-use-package.git"))
;;  (require 'quelpa-use-package))
(use-package info+
  :disabled
  :quelpa (info+ :fetcher wiki :url "https://www.emacswiki.org/emacs/info%2b.el"))
;;Inherit the terminal's environment variables
(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))
;;
(use-package org
  :ensure org-plus-contrib
  :config (require 'ox-extra)
          (ox-extras-activate '(ignore-headlines)))
;;
;;Org Mod Config
;;Default mode
(setq initial-major-mode 'org-mode)
;; Replace the content marker, “⋯”, with a nice unicode arrow.
(setq org-ellipsis " ⤵")

;; Fold all source blocks on startup.
(setq org-hide-block-startup t)

;; Lists may be labelled with letters.
(setq org-list-allow-alphabetical t)

;; Avoid accidentally editing folded regions, say by adding text after an Org “⋯”.
(setq org-catch-invisible-edits 'show)

;; I use indentation-sensitive programming languages.
;; Tangling should preserve my indentation.
(setq org-src-preserve-indentation t)

;; Tab should do indent in code blocks
(setq org-src-tab-acts-natively t)

;; Give quote and verse blocks a nice look.
(setq org-fontify-quote-and-verse-blocks t)

;; Pressing ENTER on a link should follow it.
(setq org-return-follows-link t)
;;
;;Loading custom file
(setq custom-file "~/.emacs.d/custom.el")
(ignore-errors (load custom-file)) ;;
