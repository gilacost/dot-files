SSH := $(shell command -v ssh 2>/dev/null)

ifdef SSH
INSTALLERS += ssh
CLEANERS   += clean_ssh

SSH_CONFIG_DIR := ~/.ssh
SSH_CONFIG_SRC := $(DOTFILES)/ssh/config
SSH_CONFIG_DST := $(DST_DIR)/.ssh/config

.PHONY: ssh clean_ssh

ssh: banner_install_ssh $(SSH_CONFIG_DST)

$(SSH_CONFIG_DST):
	$(LINK) $(SSH_CONFIG_SRC) $@


clean_ssh: banner_clean_ssh
	$(RM) $(SSH_CONFIG_SRC)

endif
