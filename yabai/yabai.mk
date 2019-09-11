YABAI := $(shell command -v ls 2>/dev/null) #need to be updated with chunkmd

ifdef YABAI
INSTALLERS += yabai
CLEANERS   += clean_yabai

YABAI_SRC := $(DOTFILES)/yabai/yabairc
YABAI     := $(DST_DIR)/.yabairc

.PHONY: yabai clean_yabai

yabai: banner_install_yabai $(YABAI)

$(YABAI):
	$(LINK) $(YABAI_SRC) $@


clean_chunkwmrc: banner_clean_yabai
	$(RM) $(YABAI)

endif
