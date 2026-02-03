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

### Quick Setup with Shell Functions

The easiest way to set up a development shell is using the shell functions available from anywhere:

```bash
# List all available shells (run from ANY directory)
set-dev-shell --list

# Get and set the latest Elixir shell (run from YOUR PROJECT directory)
cd ~/my-elixir-project
set-dev-shell --latest elixir

# Get and set the latest Terraform shell
cd ~/my-terraform-project
set-dev-shell --latest terraform

# Set a specific shell directly
cd ~/my-project
set-dev-shell elixir_1_18_1_erlang_27_2
```

The function will create a `.envrc` file in your current directory with the appropriate `use flake` directive and offer to use either a local path or GitHub reference.

**Note**: These functions are available globally after the dotfiles are installed, so you can run them from any project directory!

**Custom Installation Location**: If your dotfiles are not at `~/Repos/dot-files`, set the `DOTFILES_PATH` environment variable:
```bash
export DOTFILES_PATH=/path/to/your/dotfiles
```

### Direct Script Usage

If you prefer to call the scripts directly (e.g., from CI or other contexts):

```bash
# From the dotfiles directory
~/Repos/dot-files/utilities/set_dev_shell.sh --list

# Or with full path from anywhere
~/Repos/dot-files/utilities/set_dev_shell.sh --latest elixir
```

### Manual Setup

You can also manually add a remote shell to your `.envrc`:

1. Add a remote shell to your `.envrc`:
   ```bash
   echo "use flake /Users/<your-username>/Repos/dot-files#elixir_1_18_1_erlang_27_2" > .envrc
   echo "use flake github:gilacost/dot-files#elixir_1_18_1_erlang_27_2" > .envrc
   ```

2. Allow `direnv` to load the environment:
   ```bash
   direnv allow
   ```

Now, your shell environment will automatically load the specified development shell whenever you enter the directory.

---

## Managing Development Shells

### Checking for Updates

To check the current versions of all development shells (run from any directory):

```bash
check-shell-versions
```

Or call the script directly:

```bash
~/Repos/dot-files/utilities/check_shell_versions.sh
```

This will display:
- Current latest versions for Elixir, Terraform, Redis, and OpenTofu
- All available dev shells
- Suggestions for adding new versions

### Debugging Development Shells

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

## Automated Updates

This repository includes a GitHub Actions workflow that automatically:
- Updates Nix flake dependencies every Monday at 9:00 AM UTC
- Tests the build with the updated dependencies
- Verifies that Neovim starts without errors
- Creates a pull request with the changes

The workflow can also be triggered manually from the Actions tab.

### Workflow Features

- **Automated Dependency Updates**: Uses `nix flake update` to update all dependencies
- **Build Testing**: Ensures the system builds successfully after updates
- **Neovim Validation**: Tests that Neovim starts without errors
- **Pull Request Creation**: Automatically creates a PR for review with detailed information

---

## Post-Installation Notes

- Configure right-click functionality on the Magic Mouse.
- Configure any custom `.zshrc_local` settings as needed.
- Tree-sitter grammars are pre-installed via Nix (using `nvim-treesitter.withAllGrammars`)

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
