pkgs: ''
  ${builtins.readFile ~/.config/init.lua}
''
# STRINGREPLACE SOMETHING {{ELIXIR_LS_BIN}} for => "${pkgs.elixir_ls}/bin/elixir-ls"
