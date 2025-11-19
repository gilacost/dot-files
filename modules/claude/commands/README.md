# Custom Claude Commands

This directory is for your personal Claude Code commands that will be merged with the humanlayer commands.

## How it works

1. Commands from [humanlayer/humanlayer](https://github.com/humanlayer/humanlayer/tree/main/.claude/commands) are fetched automatically
2. Any `.md` files you add to this directory will be included alongside (or override) the humanlayer commands
3. When you run `darwin-rebuild switch`, the commands will be deployed to `~/.claude/commands/`

## Adding a custom command

Simply create a `.md` file in this directory. For example:

```markdown
# my-custom-command.md

You are an expert at doing something specific.

When the user asks you to do X, you should:
1. Do this
2. Then do that
3. Finally do something else
```

Then rebuild your system:
```bash
darwin-rebuild switch --flake "./#$(hostname | sed -E 's/\.local//g')"
```

## Updating humanlayer commands

To update to the latest humanlayer commands, update the `rev` or `sha256` in `modules/claude/default.nix` and rebuild.
