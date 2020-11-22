# Makefile to install all dotfiles
#
# $ make # install all dotfiles
# $ make nvim # install nvim dotfiles
#
# $ make clean # uninstall all dotfiles
# $ make clean_vim # uninstall vim dotfiles

DOTFILES := $(PWD)
DST_DIR  := $(HOME)

# Use XDG_CONFIG_HOME env var if possible.
ifdef XDG_CONFIG_HOME
	CONFIG_DIR := $(XDG_CONFIG_HOME)
endif
CONFIG_DIR ?= $(DST_DIR)/.config

LINK  := ln -sf
MKDIR := mkdir -p
CLONE := git clone
RM    := rm -fr
CP 		:= cp -fr

.PHONY: default install clean

default: install

banner_install_%:
	@echo ""
	@echo "+ Installing $* files"

banner_clean_%:
	@echo ""
	@echo "- Removing $* files"
#############GIT#########################
GIT := $(shell command -v git 2>/dev/null)

ifdef GIT
INSTALLERS += git
CLEANERS   += clean_git

GITCONFIG_SRC := $(DOTFILES)/git/gitconfig
GITCONFIG     := $(DST_DIR)/.gitconfig
GITIGNORE_SRC := $(DOTFILES)/git/gitignore
GITIGNORE     := $(DST_DIR)/.gitignore

.PHONY: git clean_git

git: banner_install_git $(GITCONFIG) $(GITIGNORE)

$(GITCONFIG):
	$(RM) $(GITCONFIG)
	$(LINK) $(GITCONFIG_SRC) $@

$(GITIGNORE):
	$(RM) $(GITIGNORE)
	$(LINK) $(GITIGNORE_SRC) $@

clean_git: banner_clean_git
	$(RM) $(GITCONFIG)
	$(RM) $(GITIGNORE)
endif
#############GIT#########################
#############SKHD########################
SKHDRC := $(shell command -v ls 2>/dev/null) #change to be skhdrc

ifdef SKHDRC
INSTALLERS += skhdrc
CLEANERS   += clean_skhdrc

SKHDRC_SRC := $(DOTFILES)/skhd/skhdrc
SKHDRC     := $(DST_DIR)/.skhdrc


.PHONY: skhdrc clean_skhdrc

skhdrc: banner_install_skhdrc $(SKHDRC)

$(SKHDRC):
	$(LINK) $(SKHDRC_SRC) $@

clean_skhdrc: banner_clean_skhdrc
	$(RM) $(SKHDRC)

endif
#############SKHD########################
#############KITTY#######################
KITTY := $(shell command -v ls 2>/dev/null)

ifdef KITTY
INSTALLERS += kitty
CLEANERS   += clean_kitty

KITTY_CONFIG_DIR   := ~/.config/kitty
KITTY_CONFIG_SRC   := $(DOTFILES)/kitty/kitty.conf
KITTY_CONFIG       := $(KITTY_CONFIG_DIR)/kitty.conf
KITTY_NVIM_SES_SRC := $(DOTFILES)/kitty/nvim.session
KITTY_NVIM_SES     := $(DST_DIR)/.nvim.session

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
#############KITTY#######################
##############NVIM########################
NVIM := $(shell command -v nvim 2>/dev/null)

ifdef NVIM
INSTALLERS += nvim
CLEANERS   += clean_nvim

NVIM_SRC_DIR  := $(DOTFILES)/nvim
NVIM_DST_DIR  := $(CONFIG_DIR)/nvim
NVIM_PLUG_URL := https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
NVIM_PLUG     := $(NVIM_DST_DIR)/autoload/plug.vim

.PHONY: nvim clean_nvim

nvim: banner_install_nvim $(NVIM_DST_DIR) $(NVIM_PLUG)

$(NVIM_DST_DIR):
				$(LINK) $(NVIM_SRC_DIR) $@

$(NVIM_PLUG): $(NVIM_DST_DIR)
				$(MKDIR) $(@D)
				curl -fLo $@ $(NVIM_PLUG_URL)
				nvim +PlugInstall +qa

clean_nvim: banner_clean_nvim
				$(RM) $(NVIM_DST_DIR)
endif
##############NVIM########################
##############SSH#########################
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
##############SSH#########################
##############ZSH#########################
ZSH := $(shell command -v zsh 2>/dev/null)

ifdef ZSH
INSTALLERS += zsh
CLEANERS   += clean_zsh


ZSHRC_SRC := $(DOTFILES)/zsh/zshrc
ZSHRC     := $(DST_DIR)/.zshrc
P10K_SRC  := $(DOTFILES)/zsh/p10k.zsh
P10K      := $(DST_DIR)/.p10k.zsh

OH_MY_ZSH_URL := git://github.com/robbyrussell/oh-my-zsh.git
OH_MY_ZSH_DST := $(DST_DIR)/.oh-my-zsh

.PHONY: zsh clean_zsh

zsh: banner_install_zsh $(ZSHRC) $(OH_MY_ZSH_DST) $(P10K)

$(ZSHRC):
				@touch $(DST_DIR)/.zshrc_local
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
##############ZSH#########################
##############WAKA########################
WAKA := $(shell command -v ls 2>/dev/null)

ifdef WAKA
INSTALLERS += waka
CLEANERS   += clean_waka

WAKA_CONFIG_SRC := $(DOTFILES)/wakatime/wakatime.cfg
WAKA_CONFIG_DST := $(DST_DIR)/.wakatime.cfg

.PHONY: waka clean_waka

waka: banner_install_waka $(WAKA_CONFIG_DST)

$(WAKA_CONFIG_DST):
				$(LINK) $(WAKA_CONFIG_SRC) $@


clean_waka: banner_clean_waka
				$(RM) $(WAKA_CONFIG_SRC)
endif
##############WAKA########################
##############COC#########################
COC := $(shell command -v ls 2>/dev/null)

ifdef COC
INSTALLERS += coc
CLEANERS   += clean_coc

COC_CONFIG_SRC := $(DOTFILES)/coc/coc-settings.json
COC_CONFIG_DST := $(DST_DIR)/.config/coc-settings.json

.PHONY: coc clean_coc

coc: banner_install_coc $(COC_CONFIG_DST)

$(COC_CONFIG_DST):
				$(LINK) $(COC_CONFIG_SRC) $@

clean_coc: banner_clean_coc
				$(RM) $(COC_CONFIG_SRC)
endif
##############COC#########################
##############ASDF########################
ASDF := $(shell command -v asdf 2>/dev/null)

ifdef ASDF
INSTALLERS += asdf
CLEANERS   += clean_asdf

ASDF_SRC := $(DOTFILES)/asdf/tool-versions
ASDF_DST := $(DST_DIR)/.tool-versions


.PHONY: asdf clean_asdf

asdf: banner_install_tool_versions $(ASDF_DST)

$(ASDF_DST):
				$(LINK) $(ASDF_SRC) $@
				cd ${HOME} && asdf install

clean_asdf: banner_clean_asdf
				$(RM) $(ASDF_DST)

endif
##############ASDF########################

install: $(INSTALLERS)

clean: $(CLEANERS)
