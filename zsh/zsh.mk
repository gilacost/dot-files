ZSH := $(shell command -v zsh 2>/dev/null)

ifdef ZSH
INSTALLERS += zsh
CLEANERS   += clean_zsh

ZSHRC_SRC         := $(DOTFILES)/zsh/zshrc
ZSHRC             := $(DST_DIR)/.zshrc
ZPROFILE_SRC      := $(DOTFILES)/zsh/zprofile
ZPROFILE          := $(DST_DIR)/.zprofile
OH_MY_ZSH_URL     := git://github.com/robbyrussell/oh-my-zsh.git
OH_MY_ZSH_DST     := $(DST_DIR)/.oh-my-zsh
BASE16_COLORS_DST := $(CONFIG_DIR)/base16-shell
BASE16_COLORS_URL := https://github.com/chriskempson/base16-shell.git

.PHONY: zsh clean_zsh

zsh: banner_install_zsh $(ZSHRC) $(ZPROFILE) $(OH_MY_ZSH_DST) $(BASE16_COLORS_DST)

$(ZSHRC):
	$(LINK) $(ZSHRC_SRC) $@

$(ZPROFILE):
	$(LINK) $(ZPROFILE_SRC) $@

$(BASE16_COLORS_DST):
	$(CLONE) $(BASE16_COLORS_URL) $@

$(OH_MY_ZSH_DST):
	$(CLONE) $(OH_MY_ZSH_URL) $@

clean_zsh: banner_clean_zsh
	$(RM) $(ZSHRC)
	$(RM) $(ZPROFILE)
	$(RM) $(OH_MY_ZSH_DST)

endif


