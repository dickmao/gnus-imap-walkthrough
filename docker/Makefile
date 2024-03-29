SHELL := /bin/bash
REPO := $(shell git rev-parse --show-toplevel)
GMAIL_USER := $(shell cat gmail-user 2>/dev/null)
GMAIL_USER2 := $(shell cat gmail-user2 2>/dev/null)
ifeq ($(CI),true)
CI_SKIP_MBSYNC := true
else
CI_SKIP_MBSYNC := "mbsync -qq -a"
endif
DOVECOT_PASSWORD := weak_password

.PHONY: all
all: Dockerfile
	DOCKER_BUILDKIT=1 docker build --progress=plain --secret id=mysecret,src=<(gpg --export-secret-key) --force-rm -t gnus:latest .

.PHONY: clean
clean:
	-git clean -dfX

.PHONY: run
run: all
	docker run -ti --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix gnus

.PHONY: test
test: clean
	@echo nnreddit.user > gmail-user
	@echo nnreddit.user > gmail-user2
	@cp $(REPO)/nnreddit.user.gpg .
	@ln -s nnreddit.user.gpg gmail-password.gpg
	$(MAKE) all
	$(MAKE) clean

gmail-user:
	$(eval GMAIL_USER := $(shell read -ep "Gmail User: " ; echo "$${REPLY}"))
	@echo $(GMAIL_USER) > $@

gmail-user2: gmail-user
	$(eval GMAIL_USER := $(shell cat $<))
	$(eval GMAIL_USER2 := $(GMAIL_USER))
	@echo $(GMAIL_USER2) > $@

gmail-password.gpg: gmail-user2
	@rm -f $(GMAIL_USER).gpg
	$(eval GMAIL_PASSWORD := $(shell read -es -p "Gmail Password: " ; echo "$${REPLY}"))
	@echo
	@gpg --batch --default-recipient-self --for-your-eyes-only --output $(GMAIL_USER).gpg --encrypt <(echo "$(GMAIL_PASSWORD)")
	@ln -s $(GMAIL_USER).gpg $@

dot.msmtprc: gmail-password.gpg $(REPO)/$@
	GMAIL_USER=$(GMAIL_USER) envsubst < $(REPO)/$@ > $@

dot.mbsyncrc: gmail-password.gpg $(REPO)/$@
	GMAIL_USER=$(GMAIL_USER) GMAIL_USER2=$(GMAIL_USER2) HOTMAIL_USER=hotmail.user YAHOO_USER=yahoo.user envsubst < $(REPO)/$@ > $@

dovecot.users: gmail-password.gpg
	GMAIL_USER=$(GMAIL_USER) DOVECOT_PASSWORD=$(DOVECOT_PASSWORD) envsubst '$${GMAIL_USER} $${DOVECOT_PASSWORD}' < $(REPO)/$@ > $@

dot.authinfo: dovecot.users $(REPO)/$@
	GMAIL_USER=$(GMAIL_USER) DOVECOT_PASSWORD=$(DOVECOT_PASSWORD) envsubst < $(REPO)/$@ > $@

dot.emacs: gmail-password.gpg $(REPO)/$@
	GMAIL_USER=$(GMAIL_USER) GMAIL_USER2=$(GMAIL_USER2) HOTMAIL_USER=hotmail.user YAHOO_USER=yahoo.user envsubst < $(REPO)/$@ > $@

dot.gnus: gmail-password.gpg $(REPO)/$@
	GMAIL_USER=$(GMAIL_USER) GMAIL_USER2=$(GMAIL_USER2) HOTMAIL_USER=hotmail.user YAHOO_USER=yahoo.user envsubst < $(REPO)/$@ > $@

Dockerfile: Dockerfile.in dot.authinfo dot.mbsyncrc dot.msmtprc dot.emacs dot.gnus
	GMAIL_USER=$(GMAIL_USER) CI_SKIP_MBSYNC=$(CI_SKIP_MBSYNC) envsubst '$${GMAIL_USER} $${CI_SKIP_MBSYNC}' < $@.in > $@
