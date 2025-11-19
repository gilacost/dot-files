{ pkgs, config, lib, ... }:
let
  # Fetch the humanlayer repository for Claude commands
  humanlayerRepo = pkgs.fetchFromGitHub {
    owner = "humanlayer";
    repo = "humanlayer";
    rev = "main";
    sha256 = "sha256-ajYV3XEYD5kfQCPwtx1uGPlCD/+huKjTUQgVEIjX/To=";
  };

  # Path to humanlayer commands
  humanlayerCommands = "${humanlayerRepo}/.claude/commands";

  # Custom commands directory (for your own commands)
  customCommandsPath = ./commands;

in
{
  # Create .claude directory structure
  home.file.".claude/commands" = {
    source = pkgs.runCommand "claude-commands" {} ''
      mkdir -p $out

      # Copy humanlayer commands
      if [ -d ${humanlayerCommands} ]; then
        cp -r ${humanlayerCommands}/* $out/ || true
      fi

      # Copy custom commands (these will override humanlayer ones if they have the same name)
      if [ -d ${customCommandsPath} ]; then
        cp -r ${customCommandsPath}/* $out/ 2>/dev/null || true
      fi
    '';
  };

  # Preserve existing .claude/settings.local.json if it exists
  home.activation.preserveClaudeSettings = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ -f "$HOME/.claude/settings.local.json.backup" ]; then
      $DRY_RUN_CMD mv $VERBOSE_ARG "$HOME/.claude/settings.local.json.backup" "$HOME/.claude/settings.local.json"
    fi
  '';
}
