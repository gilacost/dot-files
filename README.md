# My Dot-Files

[![Built with Nix](https://img.shields.io/badge/Built_With-Nix-5277C3.svg?logo=nixos&labelColor=73C3D5)](https://builtwithnix.org)

Comprehensive macOS configurations managed and expressed with [Nix](https://nixos.org/nix). This repository also includes a streamlined installation script for setting up Homebrew, Nix, and system configurations.

---

## Features

- Automated setup for Homebrew, Nix, and essential configurations.
- Modular macOS configurations for developers.
- Built-in development shell management.

---

## Prerequisites

Before running the installation script, ensure the following are installed on your system:

1. **Xcode Command Line Tools**: Install via:
   ```bash
   xcode-select --install
   ```
2. **Git**: Verify with `git --version` and install via Xcode if not available.

---

## Installation

### Using the Install Script

The `install.sh` script automates the setup process, including:
- Installing **Homebrew** (if not already installed).
- Installing **Nix** with specific configurations and experimental features.
- Setting the system hostname.
- Installing Rosetta (if applicable).
- Preparing essential directories and linking configurations.

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/dot-files.git
   cd dot-files
   ```

2. Run the install script:
   ```bash
   export HOSTNAME=your-hostname
   ./install.sh
   ```

   If you don’t provide a hostname, it defaults to `buque`.

3. Reboot your machine.

4. Complete the following post-installation tasks:
   - Configure the keyboard layout to **British PC**.
   - Enable `FN` + `ESC` functionality to toggle the escape key.
   - Import your GPG keys:
     ```bash
     gpg --import secrets/g.key
     ```
   - Log into your password manager and configure any required keys:
     ```bash
     git-crypt unlock <decoded-key>
     ```

---

## Script Details

The `install.sh` script performs the following actions:

1. **Install Homebrew** (if not already installed):
   - Installs using the official [Homebrew installation script](https://brew.sh/).

2. **Install Nix** (if not already installed):
   - Installs version `2.25.3` with the following experimental features enabled:
     - `nix-command`
     - `flakes`
     - `repl-flake`

3. **Set System Hostname**:
   - Configures the system hostname, local hostname, and computer name using the `HOSTNAME` environment variable.

4. **Rosetta Installation**:
   - Installs Rosetta for compatibility with x86 applications.

5. **Directory Setup**:
   - Creates essential directories like `.config/kitty`, `.config/peco`, and `.ssh`.

6. **Nix Configuration**:
   - Links the custom Nix configuration file to `/etc/nix/nix.conf`.

7. **Rebuild System**:
   - Builds and switches the macOS configuration using `darwin-rebuild`.

---

## Using Remote Development Shells

You can easily access remote development shells defined in this flake. Here's how:

1. Add a remote shell to your `.envrc`:
   ```bash
   echo "use flake github:gilacost/dot-files#elixir_1_18_1_erlang_27_2" > .envrc
   ```

2. Allow `direnv` to load the environment:
   ```bash
   direnv allow
   ```

Now, your shell environment will automatically load the specified development shell whenever you enter the directory.

---

## Debugging Development Shells

The repository supports multiple development shells defined in `dev_shells/default.nix`. To list available shells dynamically:

1. Run the following command to show all available shells:
   ```bash
   nix flake show ./#devShells
   ```

2. Load a specific shell with:
   ```bash
   nix develop ./#<shell-name>
   ```

   For example:
   ```bash
   nix develop ./#elixir_1_18_1_erlang_27_2
   ```

   Replace `<shell-name>` with any valid shell listed in the output of `nix flake show`.

---

## Post-Installation Notes

- Configure right-click functionality on the Magic Mouse.
- Configure any custom `.zshrc_local` settings as needed.
- Install Tree-sitter modules in Neovim:
  ```bash
  nvim
  :TSInstall all
  ```

---

## TODO

- gh auth login --web -h github.com
- first time gh copilot alias -- zsh
- review gh in dot-files

## License

This repository is licensed under the [MIT License](LICENSE).

<!-- Next steps: -->

<!-- - [ ] secrets into age -->

<!-- TODO: -->

<!-- - [ ] emoji shortcut -->
<!-- - [ ] British pc is not in keyboard lists by defaults -->
<!-- - [ ] keyboards do not appear in top bar -->
<!-- - [ ] system preferences in the dock -->
<!-- - [ ] battery percentage are not in the top bar -->
<!-- - [ ] touch zsh_local -->
<!-- - [ ] hadolint -->
<!-- - [ ] kubernetes YAML schemas investigate -->
<!-- - [ ] youtube dl -->
<!-- - [ ] review all maps MAKE A TODO and LIST THEM SOME WHERE PRINTABLE -->
<!-- - [ ] key rotation -->

<!-- Si hay problema con lost sitter parsers rm -rf cd ~/.local/share/site -->

<!-- TODO lua -->
<!-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/ -->
<!-- - [ ] lualine.vim REVIEW -->
<!-- - [ ] mappings.lua -->
<!-- - [ ] projections.vim REVIEW move to -->
<!-- - [ ] rename file -->
<!-- - [ ] cmp, lsp config and lsptrouble review -->

<!-- TODO include the config file in .ssh/ copied from 1password developer settings -->
<!-- killall ssh-agent; eval `ssh-agent` -->

<!-- ## 1password -->

<!-- https://developer.1password.com/docs/cli/shell-plugins/github/ -->
