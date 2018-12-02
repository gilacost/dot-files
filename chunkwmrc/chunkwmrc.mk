CHUNKWMRC := $(shell command -v ls 2>/dev/null) #need to be updated with chunkmd

ifdef CHUNKWMRC
INSTALLERS += chunkwmrc
CLEANERS   += clean_chunkwmrc

CHUNKWMRC_SRC := $(DOTFILES)/chunkwmrc/chunkwmrc
CHUNKWMRC     := $(DST_DIR)/.chunkwmrc

.PHONY: chunkwmrc clean_chunkwmrc

chunkwmrc: banner_install_chunkwmrc $(CHUNKWMRC)

$(CHUNKWMRC):
	$(LINK) $(CHUNKWMRC_SRC) $@


clean_chunkwmrc: banner_clean_chunkwmrc
	$(RM) $(CHUNKWMRC)

endif


