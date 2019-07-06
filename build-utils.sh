#!/bin/bash -eu

function verify-circleci-gpg {
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
