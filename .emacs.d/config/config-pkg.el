(use-package markdown-mode
  :if my/laptop-p
  :mode ("\\.\\(njk\\|md\\)\\'" . markdown-mode))