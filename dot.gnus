(setq sendmail-program "msmtp")

(require 'gnus-demon)
(add-hook 'gnus-startup-hook
          (apply-partially #'gnus-demon-add-handler 'gnus-demon-scan-news 10 t))

(defsubst my-msmtp-get (server field)
  "Get FIELD's rhs for SERVER's entry in .msmtprc."
  (when (executable-find "msmtp")
    (string-trim
     (shell-command-to-string
      (format
       "msmtp -a %s -P </dev/null 2>/dev/null | grep ^%s | cut -d' ' -f3"
       server field)))))

(add-hook 'message-setup-hook
          (lambda ()
            "Figure out who to send as.

\"drv\" remarks in `gnus-setup-message' why prevailing `gnus-newsgroup-name' cannot be used.
Regardless, we use it if it's available, and resort to *Group* buffer as a backup.
"
            (require 'subr-x)
            ;; in a hack, `gnus-group-mail' sets `gnus-newsgroup-name' to empty string
            (if-let ((group (cond ((not (zerop (length gnus-newsgroup-name)))
                                   gnus-newsgroup-name)
                                  ((buffer-live-p (get-buffer gnus-group-buffer))
                                   (with-current-buffer gnus-group-buffer
                                     (gnus-group-group-name))))))
                (let* ((method (gnus-find-method-for-group group))
                       (apropos-from (when (eq 'nnimap (nth 0 method))
                                       (my-msmtp-get (nth 1 method) "from"))))
                  (unless (zerop (length apropos-from))
                    (save-excursion
                      (message-replace-header "From" apropos-from)))))))

(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

(add-function
 :override (symbol-function 'nnimap-get-groups)
 (lambda ()
   (erase-buffer)
   (let ((sequence (nnimap-send-command "LIST \"\" \"*\""))
         groups)
     (nnimap-wait-for-response sequence)
     (subst-char-in-region (point-min) (point-max)
                           ?\\ ?% t)
     (goto-char (point-min))
     (nnimap-unfold-quoted-lines)
     (goto-char (point-min))
     (while (search-forward "* LIST " nil t)
       (let ((flags (mapcar (lambda (x) (intern (downcase (symbol-name x))))
                            (read (current-buffer))))
             (_separator (read (current-buffer)))
             (group (buffer-substring-no-properties
                     (progn (skip-chars-forward " \"")
                            (point))
                     (progn (end-of-line)
                            (skip-chars-backward " \r\"")
                            (point)))))
         (unless (member '%noselect flags)
           (push (utf7-decode (if (stringp group)
                                  group
                                (format "%s" group))
                              t)
                 groups))))
     (nreverse groups))))
