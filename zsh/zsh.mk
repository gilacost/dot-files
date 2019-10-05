ZSH := $(shell command -v zsh 2>/dev/null)

ifdef ZSH
INSTALLERS += zsh
CLEANERS   += clean_zsh


ZSHRC_SRC								:= $(DOTFILES)/zsh/zshrc
ZSHRC										:= $(DST_DIR)/.zshrc

P10K_SRC								:= $(DOTFILES)/zsh/p10k.zsh
P10K    								:= $(DST_DIR)/.p10k.zsh

OH_MY_ZSH_URL						:= git://github.com/robbyrussell/oh-my-zsh.git
OH_MY_ZSH_DST						:= $(DST_DIR)/.oh-my-zsh

.PHONY: zsh clean_zsh

zsh: banner_install_zsh $(ZSHRC) $(OH_MY_ZSH_DST) $(P10K)

$(ZSHRC):
	$(LINK) $(ZSHRC_SRC) $@

$(P10K):
	$(LINK) $(P10K_SRC) $@

$(OH_MY_ZSH_DST):
	$(CLONE) $(OH_MY_ZSH_URL) $@

clean_zsh: banner_clean_zsh
	$(RM) $(ZSHRC)
	$(RM) $(OH_MY_ZSH_DST)
	$(RM) $(P10K)

endif
