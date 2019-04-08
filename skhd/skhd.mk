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


