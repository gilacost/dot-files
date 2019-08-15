ZSH := $(shell command -v zsh 2>/dev/null)

ifdef ZSH
INSTALLERS += zsh
CLEANERS   += clean_zsh


ZSHRC_SRC								:= $(DOTFILES)/zsh/zshrc
ZSHRC										:= $(DST_DIR)/.zshrc

OH_MY_ZSH_URL						:= git://github.com/robbyrussell/oh-my-zsh.git
OH_MY_ZSH_DST						:= $(DST_DIR)/.oh-my-zsh

# ZSH_AUTOSUGGESTIONS_URL := git://github.com/zsh-users/zsh-autosuggestions.git
# ZSH_AUTOSUGGESTIONS_DST := $ZSH_CUSTOM/plugins/zsh-autosuggestion
.PHONY: zsh clean_zsh

# zsh: banner_install_zsh $(ZSHRC) $(OH_MY_ZSH_DST) $(ZSH_AUTOSUGGESTIONS_DST) $(BASE16_COLORS_DST)
zsh: banner_install_zsh $(ZSHRC) $(OH_MY_ZSH_DST)

$(ZSHRC):
	$(LINK) $(ZSHRC_SRC) $@

# $(ZSH_AUTOSUGGESTIONS_DST):
# 	$(CLONE) $(ZSH_AUTOSUGGESTIONS_URL) $@

$(OH_MY_ZSH_DST):
	$(CLONE) $(OH_MY_ZSH_URL) $@

clean_zsh: banner_clean_zsh
	$(RM) $(ZSHRC)
	$(RM) $(ZPROFILE)
	$(RM) $(OH_MY_ZSH_DST)

endif


