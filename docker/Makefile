SHELL := /bin/bash
REPO := $(shell git rev-parse --show-toplevel)
all:
	@echo what now

gmail-user:
	$(eval GMAIL_USER := $(shell read -ep "Gmail User: " ; echo $$REPLY))
	$(eval GMAIL_PASSWORD := $(shell read -es -p "Gmail Password: " ; echo $$REPLY))
	rm -f $(GMAIL_USER).gpg
	@echo
	@gpg --batch --default-recipient-self --for-your-eyes-only --output $(GMAIL_USER).gpg --encrypt <(echo $(GMAIL_PASSWORD))

dovecot.users: gmail-user
	$(eval DOVECOT_PASSWORD := weak_password)
	GMAIL_USER=$(GMAIL_USER) DOVECOT_PASSWORD=$(DOVECOT_PASSWORD) envsubst '$${GMAIL_USER} $${DOVECOT_PASSWORD}' < $(REPO)/dovecot.users > $@

dot.authinfo: dovecot.users
	GMAIL_USER=$(GMAIL_USER) DOVECOT_PASSWORD=$(DOVECOT_PASSWORD) envsubst < $(REPO)/dot.authinfo > $@

Dockerfile: dot.authinfo
	GMAIL_USER=$(GMAIL_USER) envsubst '$${GMAIL_USER}'< Dockerfile.in > $@
