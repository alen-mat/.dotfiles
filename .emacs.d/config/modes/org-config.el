(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(defun org-mode-config()
  ;; Replace the content marker, “⋯”, with a nice unicode arrow.
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
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

  (defun my/org-mode/load-prettify-symbols () "Prettify org mode keywords"
    (interactive)
    (setq prettify-symbols-alist
      (mapcan (lambda (x) (list x (cons (upcase (car x)) (cdr x))))
            '(("#+begin_src" . ?)
              ("#+end_src" . ?)
              ("#+begin_example" . ?)
              ("#+end_example" . ?)
              ("#+DATE:" . ?⏱)
              ("#+AUTHOR:" . ?✏)
              ("[ ]" .  ?☐)
              ("[X]" . ?☑ )
              ("[-]" . ?❍ )
              ("lambda" . ?λ)
              ("#+header:" . ?)
              ("#+name:" . ?﮸)
              ("#+results:" . ?)
              ("#+call:" . ?)
              (":properties:" . ?)
              (":logbook:" . ?))))
    (prettify-symbols-mode 1))

  (setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "INPROGRESS(ip)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"))))

  (setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("INPROGRESS" :foreground "green" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

  (setq org-tag-alist
    '((:startgroup)
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))

  (setq-default org-export-with-todo-keywords nil)
  (setq-default org-enforce-todo-dependencies t)

  (setq org-src-fontify-natively t
      org-src-tab-acts-natively t
      org-confirm-babel-evaluate nil
      org-edit-src-content-indentation 0)

  (my/org-mode/load-prettify-symbols)
  (load-agenda-config)
)

(defun load-agenda-config()
  (setq org-agenda-files
        '("~/Workspace/Tasks.org"))
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-email")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))
)

(provide 'org-config)
