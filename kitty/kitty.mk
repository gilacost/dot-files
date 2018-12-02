KITTY := $(shell command -v kitty 2>/dev/null)

ifdef KITTY
INSTALLERS += kitty
CLEANERS   += clean_kitty

KITTY_CONFIG_DIR   := ~/Library/Preferences/kitty
KITTY_CONFIG_SRC   := $(DOTFILES)/kitty/kitty.conf
KITTY_CONFIG       := $(KITTY_CONFIG_DIR)/kitty.conf
KITTY_NVIM_SES_SRC := $(DOTFILES)/kitty/nvim.session
KITTY_NVIM_SES     := $(DST_DIR)/.nvim.session

    # brew cask install kitty
    # mkdir -p ~/Library/Preferences/kitty
    # cp ./kitty/kitty.conf ~/Library/Preferences/kitty/kitty.conf
    # cp ./kitty/nvim.session ~/.nvim.session

.PHONY: kitty clean_kitty

kitty: banner_install_kitty $(KITTY_CONFIG_DIR) $(KITTY_CONFIG) $(KITTY_NVIM_SES)

$(KITTY_CONFIG_DIR): 
	$(MKDIR) $@

$(KITTY_CONFIG):
	$(LINK) $(KITTY_CONFIG_SRC) $@

$(KITTY_NVIM_SES):
	$(LINK) $(KITTY_NVIM_SES_SRC) $@

clean_kitty: banner_clean_kitty
	$(RM) $(KITTY_CONFIG_DIR)
	$(RM) $(KITTY_CONFIG)
	$(RM) $(KITTY_NVIM_SES)

endif


