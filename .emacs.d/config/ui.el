(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(global-visual-line-mode t)

(set-face-attribute 'default nil
                    :family "SauceCodePro Nerd Font Mono" :height 130)
(set-face-attribute 'variable-pitch nil
                    :family "SauceCodePro Nerd Font Mono" :height 110 :weight 'regular)
(set-face-attribute 'fixed-pitch nil
                    :height 110 :weight 'medium)

; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
;; Your font must have an italic face available.
(set-face-attribute 'font-lock-comment-face nil
                    :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
                    :slant 'italic)

(set-frame-parameter nil 'fullscreen 'fullboth)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'exotica t)

;; utf-8 all the things
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;Scroll Sensitivity
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

;; Uncomment the following line if line spacing needs adjusting.
;;(setq-default line-spacing 0.12)

;; Needed if using emacsclient. Otherwise, your fonts will be smaller than expected.
(add-to-list 'default-frame-alist '(font . "Source Code Pro-11"))
;; changes certain keywords to symbols, such as lamda!
(setq global-prettify-symbols-mode t)

(provide 'ui)
