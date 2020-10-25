#!/bin/bash -eu

expr="t"

function circleci-gate {
    [ ! -z "$CIRCLECI" ]
}

function circleci-test-gnus {
    circleci-gate || return 0
    emacs -Q --batch -l ~/.emacs -f gnus --eval "$expr"
}

function circleci-goose-mbsync {
    circleci-gate || return 0
    expr="(let ((gnus-tmp-active (gnus-active \"nnimap+${GMAIL_USER}:INBOX\"))) (princ (buffer-string) (function external-debugging-output)) (cl-assert (not (zerop (1+ (- (cdr gnus-tmp-active) (car gnus-tmp-active)))))))"
    inprog=0
    while [ $inprog -lt 8 ] && ! grep -sq Pulled ~/Maildir/${GMAIL_USER}/Inbox/.mbsyncstate ; do
        echo "Waiting for mbsync..."
        let inprog=inprog+1
        if systemctl --user -l --no-pager status mbsync | grep -sqi "via your web browser"; then
            echo Google locked something down at end of 2019
            expr="t"
            break
        fi
        sleep 3
    done
}

function circleci-verify-gpg {
    circleci-gate || return 0
    # I've gpg-encrypted with MY_SECRET_KEY the imap password in ${GMAIL_USER}.gpg.

    # MY_SECRET_KEY is then surreptitiously added to my CircleCI's Environment Variables.

    # If you want to do something similar for your own gpg key and imap password,
    # transmute your secret key into an ascii one-liner amenable to CircleCI:
    # gpg --export-secret-key -a 'your key id' | sed ':a;N;$!ba;s/\n/\\n/g' | xsel -ib
    # and copy from clipboard to Environment Variables under Build Settings.
    set +x
    gpg --allow-secret-key-import --import <(echo -e "$MY_SECRET_KEY") > /dev/null 2>&1
    gpg --output /dev/null --decrypt ~/Maildir/${1}.gpg > /dev/null 2>&1
    set -x
}
