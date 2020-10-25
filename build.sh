#!/bin/bash -euxE

REPO=$(git rev-parse --show-toplevel)
source ${REPO}/circleci-funcs.sh

export GMAIL_USER=nnreddit.user
export GMAIL_USER2=general.labor.631
export HOTMAIL_USER=hotmail.user
export YAHOO_USER=yahoo.user
export DOVECOT_PASSWORD=weak_password
export DOVECOT_UID=$(id -u $USER)
export DOVECOT_GID=$(id -g $USER)
export DOVECOT_HOME=${HOME}

# Squirrel auth info in ~/Maildir
if circleci-gate ; then
    mkdir -p ~/Maildir/${GMAIL_USER}
    cp ${REPO}/${GMAIL_USER}.gpg ~/Maildir/${GMAIL_USER}.gpg
else
    for user in ${GMAIL_USER} ${GMAIL_USER2}; do
        mkdir -p ~/Maildir/${user}
        read -ep "Password for ${user}: "
        echo $REPLY | gpg -ae --default-recipient-self -o ~/Maildir/${user}.gpg
    done
fi

circleci-verify-gpg ${GMAIL_USER}

# The Dovecot mail server sits between Gnus and ~/Maildir.
sudo DEBIAN_FRONTEND=noninteractive apt update -yq
sudo DEBIAN_FRONTEND=noninteractive apt-get install dovecot-common dovecot-imapd --quiet --no-force-yes
envsubst < ${REPO}/dot.authinfo >> ~/.authinfo
chmod 600 ~/.authinfo
envsubst < ${REPO}/dovecot.users > /tmp/users
sudo mv /tmp/users /etc/dovecot/
sudo chown root:dovecot /etc/dovecot/users
sudo chmod 640 /etc/dovecot/users
sudo sed -E -i 's|^#\s*(mail_debug).*|\1 = yes|' /etc/dovecot/conf.d/10-logging.conf
sudo sed -E -i 's|^#\s*(auth_debug).*|\1 = yes|' /etc/dovecot/conf.d/10-logging.conf
sudo sed -E -i 's|^#\s*(!include auth-passwdfile.*)|\1|' /etc/dovecot/conf.d/10-auth.conf
sudo sed -E -i 's|^\s*(mail_location).*|\1 = maildir:~/Maildir/%n:LAYOUT=fs:INBOX=~/Maildir/%n/Inbox|' /etc/dovecot/conf.d/10-mail.conf
sudo doveadm stop || true
sudo /etc/init.d/dovecot start

# Have mbsync fetch from your cloud-based email service every five minutes via
# `systemctl --user`.
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install isync --quiet --no-force-yes
envsubst < ${REPO}/dot.mbsyncrc > ~/.mbsyncrc
mkdir -p ~/.config/systemd/user
cp ${REPO}/mbsync.service ${REPO}/mbsync.timer ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now mbsync.timer
[ `systemctl --user is-enabled mbsync.timer` == "enabled" ]

# Msmtp provides the backend to send outgoing mail.
envsubst < ${REPO}/dot.msmtprc > ~/.msmtprc

# Basic .emacs and .gnus configuration
if ! grep -q "gnus-imap-walkthrough dot.emacs" ~/.emacs ; then
    envsubst < ${REPO}/dot.emacs >> ~/.emacs
fi
if ! grep -q "gnus-imap-walkthrough dot.gnus" ~/.gnus ; then
    envsubst < ${REPO}/dot.gnus >> ~/.gnus
fi

circleci-goose-mbsync
circleci-test-gnus
