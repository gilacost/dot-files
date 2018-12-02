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
	$(LINK) $(GITCONFIG_SRC) $@

$(GITIGNORE):
	$(LINK) $(GITIGNORE_SRC) $@

clean_git: banner_clean_git
	$(RM) $(GITCONFIG)
	$(RM) $(GITIGNORE)

endif


