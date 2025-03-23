://github.com/LionyxML/emacs-solo/blob/main/init.el
(defvar my/default-font-size 120)
(defvar my/default-variable-font-size 120)

;; Make frame transparency overridable
(defvar my/frame-transparency '(90 . 90))

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(use-package emacs
  :ensure nil
  :custom
  (completion-ignore-case t)
  (completions-format 'one-column)
  (inhibit-startup-message t)
  (initial-scratch-message "")
  (grep-find-ignored-directories
   '("SCCS" "RCS" "CVS" "MCVS" ".src" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "node_modules" "build" "dist"))
  (modify-coding-system-alist 'file "" 'utf-8)

  (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height my/default-variable-font-size :weight 'regular)
  :config
  ;; Manual customization to a seperate file

  (setq custom-file (locate-user-emacs-file "custom-vars.el"))

  ;; Set line-number-mode with relative numbering
  (setq display-line-numbers-type 'relative)
  (add-hook 'prog-mode-hook #'display-line-numbers-mode)
  
  ;; On Terminal: changes the vertical separator to a full vertical line
  ;;              and truncation symbol to a right arrow
  (set-display-table-slot standard-display-table 'vertical-border ?\u2502)
  (set-display-table-slot standard-display-table 'truncation ?\u2192)
  ;; Ibuffer filters
  (setq ibuffer-saved-filter-groups
        '(("default"
           ("org" (or
                   (mode . org-mode)
                   (name . "^\\*Org Src")
                   (name . "^\\*Org Agenda\\*$")))
           ("tramp" (name . "^\\*tramp.*"))
           ("emacs" (or
                     (name . "^\\*scratch\\*$")
                     (name . "^\\*Messages\\*$")
                     (name . "^\\*Warnings\\*$")
                     (name . "^\\*Shell Command Output\\*$")
                     (name . "^\\*Async-native-compile-log\\*$")
                     (name . "^\\*straight-")))
           ("ediff" (or
                     (name . "^\\*ediff.*")
                     (name . "^\\*Ediff.*")))
           ("dired" (mode . dired-mode))
           ("terminal" (or
                        (mode . term-mode)
                        (mode . shell-mode)
                        (mode . eshell-mode)))
           ("help" (or
                    (name . "^\\*Help\\*$")
                    (name . "^\\*info\\*$")
                    (name . "^\\*helpful"))))))
  ;; So eshell git commands open an instance of THIS config of Emacs
  (setenv "GIT_EDITOR" (format "emacs --init-dir=%s " (shell-quote-argument user-emacs-directory)))
  ;; So rebase from eshell opens with a bit of syntax highlight
  (add-to-list 'auto-mode-alist '("/git-rebase-todo\\'" . conf-mode))
  :init
  (set-window-margins (selected-window) 2 0)

  (toggle-frame-maximized)
  (select-frame-set-input-focus (selected-frame))
  (global-auto-revert-mode 1)
  (indent-tabs-mode -1)
  (recentf-mode 1)
  (repeat-mode 1)
  (savehist-mode 1)
  (save-place-mode 1)
  (winner-mode)
  (xterm-mouse-mode 1)
  (file-name-shadow-mode 1) ; allows us to type a new path without having to delete the current one

  (with-current-buffer (get-buffer-create "*scratch*")
    (insert (format "
   Loading time : %s0
   Packages     : %s
"
                    (emacs-init-time)
                    (number-to-string (length package-activated-list)))))

  (message (emacs-init-time))
  )

;;; SMERGE
(use-package smerge-mode
  :ensure nil
  :bind (:map smerge-mode-map
              ("C-c ^ u" . smerge-keep-upper)
              ("C-c ^ l" . smerge-keep-lower)
              ("C-c ^ n" . smerge-next)
              ("C-c ^ p" . smerge-previous)))

;;; DIFF
(use-package diff-mode
  :ensure nil
  :defer t
  :config
  (setq diff-default-read-only t)
  (setq diff-advance-after-apply-hunk t)
  (setq diff-update-on-the-fly t)
  (setq diff-font-lock-syntax 'hunk-also)
  (setq diff-font-lock-prettify nil))

;;; EDIFF
(use-package ediff
  :ensure nil
  :commands (ediff-buffers ediff-files ediff-buffers3 ediff-files3)
  :init
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  :config
  (setq ediff-keep-variants nil)
  (setq ediff-make-buffers-readonly-at-startup nil)
  (setq ediff-merge-revisions-with-ancestor t)
  (setq ediff-show-clashes-only t))

;;; WHICH-KEY
(use-package which-key
  :defer t
  :ensure nil
  :hook
  (after-init . which-key-mode)
  :config
  (setq which-key-separator "  ")
  (setq which-key-prefix-prefix "... ")
  (setq which-key-max-display-columns 3)
  (setq which-key-idle-delay 1.5)
  (setq which-key-idle-secondary-delay 0.25)
  (setq which-key-add-column-padding 1)
  (setq which-key-max-description-length 40))

 ;;; THEMES
(use-package modus-themes
  :ensure nil
  :defer t
  :custom
  (modus-themes-italic-constructs t)
  (modus-themes-bold-constructs t)
  (modus-themes-mixed-fonts nil)
  (modus-themes-prompts '(bold intense))
  (modus-themes-common-palette-overrides
   `((bg-main "#292D3E")
     (bg-active bg-main)
     (fg-main "#EEFFFF")
     (fg-active fg-main)
     (fg-mode-line-active "#A6Accd")
     (bg-mode-line-active "#232635")
     (fg-mode-line-inactive "#676E95")
     (bg-mode-line-inactive "#282c3d")
     ;; (border-mode-line-active "#676E95")
     ;; (border-mode-line-inactive bg-dim)
     (border-mode-line-active nil)
     (border-mode-line-inactive nil)
     (bg-tab-bar      "#242837")
     (bg-tab-current  bg-main)
     (bg-tab-other    "#242837")
     (fg-prompt "#c792ea")
     (bg-prompt unspecified)
     (bg-hover-secondary "#676E95")
     (bg-completion "#2f447f")
     (fg-completion white)
     (bg-region "#3C435E")
     (fg-region white)

     (fg-line-number-active fg-main)
     (fg-line-number-inactive "gray50")
     (bg-line-number-active unspecified)
     (bg-line-number-inactive "#292D3E")
     (fringe "#292D3E")

     (fg-heading-0 "#82aaff")
     (fg-heading-1 "#82aaff")
     (fg-heading-2 "#c792ea")
     (fg-heading-3 "#bb80b3")
     (fg-heading-4 "#a1bfff")

     (fg-prose-verbatim "#c3e88d")
     (bg-prose-block-contents "#232635")
     (fg-prose-block-delimiter "#676E95")
     (bg-prose-block-delimiter bg-prose-block-contents)

     (accent-1 "#79a8ff")

     (keyword "#89DDFF")
     (builtin "#82aaff")
     (comment "#676E95")
     (string "#c3e88d")
     (fnname "#82aaff")
     (type "#c792ea")
     (variable "#c792ea")
     (docstring "#8d92af")
     (constant "#f78c6c")))
    :config
    (modus-themes-with-colors
      (custom-set-faces
       `(tab-bar
         ((,c
           :background "#232635"
           :foreground "#A6Accd"
           ;; :box (:line-width 1 :color "#676E95")
           )))
       `(tab-bar-tab
         ((,c
           ;; :background "#232635"
           ;; :underline t
           ;; :box (:line-width 1 :color "#676E95")
         )))
       `(tab-bar-tab-inactive
         ((,c
           ;; :background "#232635"
           ;; :box (:line-width 1 :color "#676E95")
           )))))
  :init
  (load-theme 'modus-vivendi-tinted t))

;;  Customizations to the mode-line
;;
(use-package my-mode-line
  :ensure nil
  :no-require t
  :defer t
  :init
  ;; Shorten big branches names
  (defun emacs-solo/shorten-vc-mode (vc)
    "Shorten VC string to at most 20 characters.
     Replacing `Git-' with a branch symbol."
    (let* ((vc (replace-regexp-in-string "^ Git[:-]" "  " vc))) ;; Options:   ᚠ ⎇
      (if (> (length vc) 20)
          (concat (substring vc 0 20) "…")
        vc)))

  ;; Formats Modeline
  (setq-default mode-line-format
                '("%e" "  "
                  ;; (:propertize " " display (raise +0.1)) ;; Top padding
                  ;; (:propertize " " display (raise -0.1)) ;; Bottom padding
                  (:propertize "λ  " face font-lock-keyword-face)

                  (:propertize
                   ("" mode-line-mule-info mode-line-client mode-line-modified mode-line-remote))

                  mode-line-frame-identification
                  mode-line-buffer-identification
                  "   "
                  mode-line-position
                  mode-line-format-right-align
                  "  "
                  (project-mode-line project-mode-line-format)
                  "  "
                  (vc-mode (:eval (emacs-solo/shorten-vc-mode vc-mode)))
                  "  "
                  mode-line-modes
                  mode-line-misc-info
                  "  ")
                project-mode-line t
                mode-line-buffer-identification '(" %b")
                mode-line-position-column-line-format '(" %l:%c"))

  ;; Provides the Diminish functionality
  (defvar emacs-solo-hidden-minor-modes
    '(abbrev-mode
      eldoc-mode
      flyspell-mode
      smooth-scroll-mode
      outline-minor-mode
      which-key-mode))

  (defun emacs-solo/purge-minor-modes ()
    (interactive)
    (dolist (x emacs-solo-hidden-minor-modes nil)
      (let ((trg (cdr (assoc x minor-mode-alist))))
        (when trg
          (setcar trg "")))))

  (add-hook 'after-change-major-mode-hook 'emacs-solo/purge-minor-modes))
