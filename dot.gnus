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
            "From-address keyed off msmtp config if gnus-newsgroup-name in effect."
            (let* ((group (when (buffer-live-p (get-buffer gnus-group-buffer))
                            (with-current-buffer gnus-group-buffer (gnus-group-group-name))))
                   (method (gnus-find-method-for-group group))
                   (apropos-from (when (eq 'nnimap (nth 0 method))
                                   (my-msmtp-get (nth 1 method) "from"))))
              ;; drv's comment in gnus-setup-message why prevailing
              ;; gnus-newsgroup-name cannot be used
              (unless (zerop (length apropos-from))
                (save-excursion
                  (message-replace-header "From" apropos-from))))))

(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
