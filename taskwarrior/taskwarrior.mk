TASK := $(shell command -v task 2>/dev/null)

ifdef TASK
INSTALLERS += task
CLEANERS   += clean_task

TASK_CONFIG_SRC   := $(DOTFILES)/taskwarrior/taskrc
TASK_CONFIG       := $(DST_DIR)/.taskrc

.PHONY: task clean_task

task: banner_install_task $(TASK_CONFIG)

$(TASK_CONFIG):
	$(CP) $(TASK_CONFIG_SRC) $@

clean_task: banner_clean_task
	$(RM) $(TASK_CONFIG)

endif


