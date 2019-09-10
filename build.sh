#!/bin/bash -euxE

REPO=$(dirname $0)
export GMAIL_USER=nnreddit.user
export GMAIL_USER2=gmail.user2
export HOTMAIL_USER=hotmail.user
export YAHOO_USER=yahoo.user
export DOVECOT_PASSWORD=weak_password
export DOVECOT_UID=$(id -u $USER)
export DOVECOT_GID=$(id -g $USER)
export DOVECOT_HOME=${HOME}

source ${REPO}/build-utils.sh

# Bootstrap ~/Maildir
mkdir -p ~/Maildir/${GMAIL_USER}
cp ${REPO}/${GMAIL_USER}.gpg ~/Maildir/

# verify-circleci-gpg ONLY applies to the CircleCI environment (generally not applicable!).
verify-circleci-gpg ${GMAIL_USER}

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
sudo add-apt-repository --yes ppa:slgeorge/ppa
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install isync --quiet --no-force-yes
envsubst < ${REPO}/dot.mbsyncrc > ~/.mbsyncrc
mkdir -p ~/.config/systemd/user
cp ${REPO}/mbsync.service ${REPO}/mbsync.timer ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now mbsync.timer
[ `systemctl --user is-enabled mbsync.timer` == "enabled" ]

# Check that our initial run of mbsync finished.  Not applicable generally.
inprog=0
while [ $inprog -lt 10 ] && ! grep -sq Pulled ~/Maildir/${GMAIL_USER}/Inbox/.mbsyncstate ; do
    echo "Waiting for mbsync..."
    let inprog=inprog+1
    sleep 3
done

# Msmtp provides the backend to send outgoing mail.
envsubst < ${REPO}/dot.msmtprc > ~/.msmtprc

# Basic .emacs and .gnus configuration
envsubst < ${REPO}/dot.emacs >> ~/.emacs
envsubst < ${REPO}/dot.gnus >> ~/.gnus

# Test that we see messages in our inbox.  Not applicable generally.
emacs -Q --batch -l ~/.emacs -f gnus --eval "(let ((gnus-tmp-active (gnus-active \"nnimap+${GMAIL_USER}:INBOX\"))) (cl-assert (not (zerop (1+ (- (cdr gnus-tmp-active) (car gnus-tmp-active)))))))"
