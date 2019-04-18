ZSH := $(shell command -v zsh 2>/dev/null)

ifdef ZSH
INSTALLERS += zsh
CLEANERS   += clean_zsh


ZSHRC_SRC								:= $(DOTFILES)/zsh/zshrc
ZSHRC										:= $(DST_DIR)/.zshrc

OH_MY_ZSH_URL						:= git://github.com/robbyrussell/oh-my-zsh.git
OH_MY_ZSH_DST						:= $(DST_DIR)/.oh-my-zsh

ZSH_AUTOSUGGESTIONS_URL := git://github.com/zsh-users/zsh-autosuggestions.git
ZSH_AUTOSUGGESTIONS_DST := @$ZSH_CUSTOM/plugins/zsh-autosuggestion
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
# git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
# ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
BASE16_COLORS_DST				:= $(CONFIG_DIR)/base16-shell
BASE16_COLORS_URL				:= https://github.com/chriskempson/base16-shell.git

.PHONY: zsh clean_zsh

zsh: banner_install_zsh $(ZSHRC) $(OH_MY_ZSH_DST) $(ZSH_AUTOSUGGESTIONS_DST) $(BASE16_COLORS_DST)

$(ZSHRC):
	$(LINK) $(ZSHRC_SRC) $@

$(ZSH_AUTOSUGGESTIONS_DST):
	$(CLONE) $(ZSH_AUTOSUGGESTIONS_URL) $@

$(BASE16_COLORS_DST):
	$(CLONE) $(BASE16_COLORS_URL) $@

$(OH_MY_ZSH_DST):
	$(CLONE) $(OH_MY_ZSH_URL) $@

clean_zsh: banner_clean_zsh
	$(RM) $(ZSHRC)
	$(RM) $(ZPROFILE)
	$(RM) $(OH_MY_ZSH_DST)

endif


