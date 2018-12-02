ITERM := $(shell command -v ls 2>/dev/null)

ifdef ITERM
INSTALLERS += iterm
CLEANERS   += clean_iterm

ITERM_CONFIG_SRC   := $(DOTFILES)/iterm/bashrc
ITERM_CONFIG       := $(DST_DIR)/.bashrc

.PHONY: iterm clean_iterm

iterm: banner_install_iterm $(ITERM_CONFIG)

$(ITERM_CONFIG):
	$(LINK) $(ITERM_CONFIG_SRC) $@

clean_iterm: banner_clean_iterm
	$(RM) $(ITERM_CONFIG)

endif


