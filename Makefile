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

.PHONY: default install clean

default: install

banner_install_%:
	@echo ""
	@echo "+ Installing $* files"

banner_clean_%:
	@echo ""
	@echo "- Removing $* files"

include **/*.mk

install: $(INSTALLERS)

clean: $(CLEANERS)
