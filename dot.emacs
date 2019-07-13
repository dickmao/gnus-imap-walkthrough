;;; Anything coming/going to the `emacs-devel` mailing list is filed
;;; locally to folder of same name.
(let* ((nnimap-split-fancy '(| (any "emacs-devel" "emacs-devel")
                               "INBOX"))
       (server-vars `((nnimap-address "localhost")
                      (nnimap-stream network)
                      (nnimap-server-port 143)
                      (nnimap-inbox "INBOX")
                      (nnimap-split-methods 'nnimap-split-fancy)
                      (nnimap-split-fancy ,nnimap-split-fancy))))
  (setq my-secondary-select-methods
        `(,(append '(nnimap "${GMAIL_USER}") server-vars)
          ;; other Gnus message sources, e.g.,
          ;; (nntp "news.gmane.org")
          ;; (nnreddit "")
          ;; ,(append '(nnimap "${HOTMAIL_USER}") server-vars)
          ;; ,(append '(nnimap "${YAHOO_USER}") server-vars)
          )))

(custom-set-variables
 '(gnus-select-method (quote (nnnil)))
 '(gnus-secondary-select-methods my-secondary-select-methods)
 '(gnus-add-timestamp-to-message (quote log))
 '(gnus-before-startup-hook (quote (toggle-debug-on-error)))
 '(gnus-always-read-dribble-file t)
 '(mail-user-agent (quote gnus-user-agent))
 '(read-mail-command (quote gnus))
 '(send-mail-function (quote message-send-mail-with-sendmail))
 '(message-send-mail-function (quote message-send-mail-with-sendmail))
 '(message-sendmail-envelope-from (quote header))
 '(message-signature-separator "^-- *$"))