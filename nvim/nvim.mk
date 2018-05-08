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
