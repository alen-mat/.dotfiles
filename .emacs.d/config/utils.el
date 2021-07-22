(defvar my/personal-machine?
  (not (s-contains? "alen" (shell-command-to-string "uname -a")))
  "Is this my personal machine, or my work machine?")
;;(message-box ".emacs.d/init.el says hello")

(defun prelude-open-with (arg)
  "Open visited file in default external program.

      With a prefix ARG always prompt for command to use."
  (interactive "P")
  (when buffer-file-name
    (shell-command (concat
                    (cond
                     ((and (not arg) (eq system-type 'darwin)) "open")
                     ((and (not arg) (member system-type '(gnu gnu/linux gnu/kfreebsd))) "xdg-open")
                     (t (read-shell-command "Open current file with: ")))
                    " "
                    (shell-quote-argument buffer-file-name)))))
                    
(provide 'utils)
