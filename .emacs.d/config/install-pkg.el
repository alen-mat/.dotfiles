(require 'package)

(setq package-enable-at-startup nil)
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(unless (assoc-default "gnu" package-archives)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t))
(unless (assoc-default "org" package-archives)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t))
(unless (assoc-default "nongnu" package-archives)
  (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t))

(setq use-package-verbose t)
(setq use-package-always-ensure t)

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'bind-key)

(eval-when-compile
  (require 'use-package))
(require 'bind-key)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
          (ox-extras-activate '(ignore-headlines))
          (org-mode-config))

;;DOM Mod line
(use-package doom-modeline)
(doom-modeline-mode 1)

(use-package winner
  :defer t)

(use-package markdown-mode
  :if my/laptop-p
  :mode ("\\.\\(njk\\|md\\)\\'" . markdown-mode))

(use-package org-bullets
  :hook (org-mode-hook . (lambda () (org-bullets-mode 1))))

(use-package nov
  :mode ("\\.epub\\'" . nov-mode))

(use-package rainbow-mode
  :delight)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'install-pkg)
