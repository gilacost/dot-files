
if [ -x "$(command -v nvr)" ]; then
  # alias nvim=nvr
  export EDITOR="nvr --remote-wait"
else
  export EDITOR="echo 'No nesting!'"
fi
export VISUAL="$EDITOR"
alias e=$EDITOR

# # rust avoid
# # linking with cc failed
# # note: ld: library not found for -lSystem
# # https://github.com/TimNN/cargo-lipo/issues/41
# SDKROOT=`xcrun --sdk macosx --show-sdk-path`;
# export LIBRARY_PATH="$SDKROOT/usr/lib";

unsetopt BEEP

unsetopt correct

# https://docs.cachix.org/pushing
# Pushing whole /nix/store

function push_cachix {
  nix path-info --all | cachix push pepo
}

function gha() {
  latest_run_id=$(gh run list --limit 1 --json databaseId,url --jq ".[0].databaseId")
  latest_run_url=$(gh run list --limit 1 --json url --jq ".[0].url")

  if [[ "$1" == "--log" ]]; then
    gh run view --log --run-id "$latest_run_id"
  else
    open "$latest_run_url" # or xdg-open on Linux
  fi
}

function gha_peco() {
  # List GitHub Actions runs with peco and open selected run in browser
  # Shows workflow name, status, and branch
  gh run list --limit 50 --json displayTitle,status,conclusion,headBranch,url \
    --jq '.[] | "\(.displayTitle) [\(.status)] [\(.conclusion // "running")] (\(.headBranch)) \(.url)"' | \
    peco | \
    awk '{print $NF}' | \
    xargs open
}

function gsina {
  git status --porcelain \
  | awk '{ if (substr($0, 0, 2) ~ /^[ ?].$/) print $0 }' \
  | peco \
  | awk '{ print "$(git rev-parse --show-toplevel)/"$2 }'
}

function glog_peco {
  # Search through git commit messages with peco
  # Shows commits in a nice format and opens the selected one with git show
  git log --oneline --color=always --decorate | \
    peco | \
    awk '{print $1}' | \
    xargs -I {} git show --color=always {}
}

function gdiff_peco {
  # Search through git commit diffs with peco
  # Useful for finding when specific code was changed
  git log --oneline --color=always --decorate | \
    peco | \
    awk '{print $1}' | \
    xargs -I {} git diff --color=always {}^..{}
}

function glog_search {
  # Interactive search through commit messages and diffs
  # Shows full commit info in peco preview
  git log --oneline --all --decorate --color=always | \
    peco --query "$1" | \
    awk '{print $1}' | \
    xargs -I {} git show --color=always {}
}


function service_port {
  sudo netstat -tulnp "${1:-tcp}"
}

function rm_pattern {
  # removes nested folders of $1=pattern, e.g "_build"
  find . -type d -name "$1" -exec rm -rf {} +
}

function update_input {
  nix flake lock --update-input "${1:"nixpkgs"}"
}

function mise-update() {
  # Update all mise tool versions to latest available
  echo "🔄 Upgrading mise tools to latest versions..."
  echo ""

  # Use mise's built-in upgrade with --bump to update config.toml
  mise upgrade --bump

  echo ""
  echo "✅ Tools upgraded and config.toml updated"
  echo ""
  read "?🔨 Rebuild darwin configuration now? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🏗️  Rebuilding darwin configuration..."
    darwin-rebuild switch --flake ~/.nixpkgs
    echo ""
    echo "✅ Rebuild complete!"
  else
    echo "ℹ️  Skipped rebuild. Run when ready:"
    echo "  darwin-rebuild switch --flake ~/.nixpkgs"
  fi
}

function checkports_host {
  sudo nmap -sTU -O "$1"
}

### yaml for image  kubectl run kiada --image=luksa/kiada:0.1 --dry-run=client -o yaml > mypod.yaml
# kubectl run --image=tutum/curl -it --restart=Never --rm client-pod curl 10.244.2.4:8080

function ctdeps {
  mix xref graph --sink "$1" --only-nodes
}

function depstree {
  mix xref graph --sink "$1"
}

function depstreefilter {
  # Filters deps tree. Defaults to compile
  # which will only list the transitive deps
  # compile should be default
  mix xref graph --sink "$1" --label "$2"
}

function depsgraph {
  mix xref graph --format stats
}

function poyamlfimg {
  kubectl run kiada --image="$1" --dry-run=client -o yaml > "$2.yaml"
}

function insidecurl {
  kubectl run --image=praqma/network-multitool:alpine-extra -it --restart=Never --rm client-pod curl "$1"
}

function upgrade_nix {

sudo nix-env --install --file '<nixpkgs>' --attr nix cacert -I nixpkgs=channel:nixpkgs-unstable && sudo launchctl remove org.nixos.nix-daemon && sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
}

function erlv {
  cat "$(dirname $(dirname $(which erl)))/lib/erlang/releases/**/OTP_VERSION"
}

function sri_to_nix32() {
  local sri="$1"
  if [[ -z "$sri" || "$sri" == "--help" ]]; then
    echo "Usage: sri_to_nix32 sha256-<base64>"
    echo "Converts an SRI-style sha256 hash to Nix base32 format"
    echo
    echo "Example:"
    echo "  sri_to_nix32 sha256-Pybkcm3pLt0wV+S9ia/BAmM1AKp/nVSAckEzNn4KjSg="
    return 1
  fi

  nix hash convert --from sri --to nix32 "$sri"
}

function image_tags {
  curl -s "https://registry.hub.docker.com/v2/repositories/$1/tags/?page_size=${2:-200}" | jq -r '.results[].name'
}

function dockerlogin {
  echo "$CR_PAT" | docker login ghcr.io -u gilacost --password-stdin
}

function nix_prefetch() {
  local repo="$1"
  local tag="$2"

  if [[ -z "$repo" || -z "$tag" ]]; then
    echo "Usage: nix_prefetch <github_owner/repo> <tag>"
    return 1
  fi

  local url="https://github.com/${repo}"
  nix-prefetch-git --url "$url" --rev "$tag"
}

function nix_prefetch_latest() {
  local repo="$1"

  if [[ "$repo" == "--help" || -z "$repo" ]]; then
    echo "Usage: nix_prefetch_latest <github_owner/repo>"
    echo
    echo "Fetches the latest release tag from a GitHub repository using the GitHub API"
    echo "and prefetches the corresponding Git revision using nix-prefetch-git."
    echo
    echo "Examples:"
    echo "  nix_prefetch_latest elixir-lang/elixir       # => prefetch latest Elixir release"
    echo "  nix_prefetch_latest erlang/otp               # => prefetch latest OTP release"
    echo "  nix_prefetch_latest elixir-lsp/elixir-ls     # => prefetch latest ElixirLS release"
    return 0
  fi

  local tag
  tag=$(get_latest_release "$repo")

  if [[ -z "$tag" || "$tag" == "null" ]]; then
    echo "Could not determine the latest release tag for $repo"
    return 1
  fi

  echo "Latest tag for $repo: $tag"
  nix_prefetch "$repo" "$tag"
}

function get_latest_release() {
  if [[ "$1" == "--help" || -z "$1" ]]; then
    echo "Usage: get_latest_release <github_owner/repo>"
    echo
    echo "Fetch the latest release tag from a GitHub repository."
    echo
    echo "Examples:"
    echo "  get_latest_release elixir-lang/elixir       # => v1.16.2"
    echo "  get_latest_release hashicorp/terraform      # => v1.7.5"
    echo "  get_latest_release burntsushi/ripgrep       # => 13.0.0"
    echo "  get_latest_release erlang/otp               # => OTP-27.3.2"

    return 0
  fi
  local repo="$1"
  curl -s "https://api.github.com/repos/${repo}/releases/latest" \
    | jq -r '.tag_name'
}

###############
# Git + Claude #
###############

# Claude-powered git search
function gsearch() {
  # Search git history with Claude's help
  if [ -z "$1" ]; then
    echo "Usage: gsearch 'what are you looking for?'"
    echo "Example: gsearch 'when did we add authentication?'"
    return 1
  fi

  echo "Searching git history with Claude..."
  git log --all --oneline --decorate | claude "Search through this git history for: $1. Show relevant commits with explanations."
}

# Find when a function/feature was added
function gwhen() {
  if [ -z "$1" ]; then
    echo "Usage: gwhen <function_name_or_code>"
    echo "Example: gwhen 'processPayment'"
    return 1
  fi

  echo "Finding when '$1' was introduced..."
  git log -S "$1" --all --oneline --pretty=format:"%C(yellow)%h%Creset %Cgreen%ad%Creset %s" --date=short
}

# Who wrote this mess?
function gblame-ai() {
  if [ ! -f "$1" ]; then
    echo "Usage: gblame-ai <file>"
    return 1
  fi

  git blame "$1" | claude "Summarize who worked on this file and what sections they own. Group by author."
}

# Git stats with Claude insights
function gstats() {
  git log --all --pretty=format:"%an" | sort | uniq -c | sort -rn | claude "Analyze these git contributor stats and provide insights about team contributions."
}

# Show me what changed in the last N commits
function grecent() {
  local count=${1:-5}
  git log -n "$count" --oneline --color=always | claude "Summarize these recent commits and highlight any important patterns or concerns."
}

# Quick reminder of available git+claude commands
function ghelp() {
  cat << 'EOF'
Git + Claude Helper Commands
=============================

Commits & Branches:
  gcai              Generate commit message and commit
  gbai              Generate branch name and create branch
  prdai [base]      Generate PR description

History Search:
  gsearch 'query'   Search git history with Claude
  gwhen <code>      Find when code/function was added
  grecent [N]       Summarize last N commits (default 5)
  gblame-ai <file>  Summarize who owns what in a file
  gstats            Team contribution insights

Quick Claude:
  c "prompt"        Claude on current directory
  cg "prompt"       Claude with git diff context
  cfix              Fix last failed command
  cexp <file>       Explain file or concept

Existing Tools:
  glog_peco         Search commits interactively
  gdiff_peco        Search commit diffs
  glog_search       Search commits with query

Daily:
  ailog             Open today's AI workflow log

Run 'ghelp' anytime to see this list!
EOF
}

function gcai() {
  # Generate commit message with Claude
  if ! git diff --staged --quiet; then
      echo "Generating commit message with Claude..."
      COMMIT_MESSAGE=$(git diff --staged -- . ":(exclude)mix.lock" ":(exclude)package-lock.json" ":(exclude)yarn.lock" ":(exclude)pnpm-lock.yaml" | claude "Write a concise git commit message for these changes. Just the message, no explanations. Follow conventional commits format if appropriate.")

      COMMIT_MESSAGE=$(echo "$COMMIT_MESSAGE" | sed 's/^ *//;s/ *$//')

      if [[ -n "$COMMIT_MESSAGE" ]]; then
          echo "Commit message: $COMMIT_MESSAGE"
          read "?Commit with this message? (y/n) " -n 1 -r
          echo
          if [[ $REPLY =~ ^[Yy]$ ]]; then
              git commit -m "$COMMIT_MESSAGE"
              echo "✓ Committed"
          else
              echo "Cancelled"
          fi
      else
          echo "Error: Generated commit message is empty."
          return 1
      fi
  else
      echo "No staged changes to commit (or only lock files were changed)."
  fi
}

function gbai() {
  # Generate branch name with Claude
  if ! git diff --staged --quiet; then
      echo "Generating branch name with Claude..."
      BRANCH_NAME=$(git diff --staged | claude "Generate a short, descriptive git branch name for these changes. Use kebab-case. Just the branch name, nothing else.")

      BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/^ *//;s/ *$//' | tr ' ' '-' | tr -cd '[:alnum:]-')

      if [[ -n "$BRANCH_NAME" ]]; then
          echo "Branch name: $BRANCH_NAME"
          read "?Create this branch? (y/n) " -n 1 -r
          echo
          if [[ $REPLY =~ ^[Yy]$ ]]; then
              git checkout -b "$BRANCH_NAME"
              echo "✓ Switched to new branch: $BRANCH_NAME"
          else
              echo "Cancelled"
          fi
      else
          echo "Error: Generated branch name is empty."
          return 1
      fi
  else
      echo "No staged changes to create a branch."
  fi
}

function prdai() {
  # Generate PR description with Claude
  BASE_BRANCH=${1:-main}
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

  if [ "$CURRENT_BRANCH" = "$BASE_BRANCH" ]; then
      echo "You are on the $BASE_BRANCH branch. Switch to a feature branch first."
      return 1
  fi

  if ! git show-ref --quiet "refs/heads/$BASE_BRANCH"; then
      echo "Base branch $BASE_BRANCH not found locally. Fetching..."
      git fetch origin "$BASE_BRANCH:$BASE_BRANCH"
  fi

  echo "Generating PR description with Claude..."
  PR_DESCRIPTION=$(git diff "$BASE_BRANCH"..."$CURRENT_BRANCH" -- . ":(exclude)mix.lock" ":(exclude)package-lock.json" ":(exclude)yarn.lock" ":(exclude)pnpm-lock.yaml" | claude "Write a detailed PR description for these changes. Include: ## Summary (what changed), ## Why (motivation), ## Changes (bullet points), ## Testing (how to verify). Use markdown format.")

  PR_DESCRIPTION=$(echo "$PR_DESCRIPTION" | sed 's/^ *//;s/ *$//')

  if [[ -n "$PR_DESCRIPTION" ]]; then
      echo ""
      echo "Generated PR Description:"
      echo "======================================"
      echo "$PR_DESCRIPTION"
      echo "======================================"
      echo ""
      echo "Copy this for your PR, or pipe to: gh pr create --body-file -"
  else
      echo "Error: Generated PR description is empty."
      return 1
  fi
}

nixify() {
  if [ ! -e ./.envrc ]; then
    echo "use nix" > .envrc
    direnv allow
  fi
  if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
    cat > default.nix <<'EOF'
with import <nixpkgs> {};
mkShell {
  nativeBuildInputs = [
    bashInteractive
  ];
}
EOF
    "${EDITOR:-vim}" default.nix
  fi
}

flakifiy() {
  if [ ! -e flake.nix ]; then
    nix flake new -t github:nix-community/nix-direnv .
  elif [ ! -e .envrc ]; then
    echo "use flake" > .envrc
    direnv allow
  fi
  "${EDITOR:-vim}" flake.nix
}

function oom_rate() {
  if [[ -z "$1" || "$1" == "--help" ]]; then
    echo "Usage: oom_rate <log-group-name> [days]"
    echo
    echo "Calculate the rate of OutOfMemoryError events in AWS CloudWatch logs"
    echo
    echo "Arguments:"
    echo "  log-group-name    AWS CloudWatch log group name (required)"
    echo "  days              Number of days to analyze (default: 7)"
    echo
    echo "Example:"
    echo "  oom_rate /aws/chatbot/ecs-alerts-channel 14"
    return 1
  fi

  local log_group="$1"
  local days=${2:-7}
  local seconds=$((days * 86400))

  aws logs filter-log-events \
    --log-group-name "$log_group" \
    --start-time $(($(date +%s) - $seconds))000 \
    --filter-pattern "OutOfMemoryError" \
    --region ${AWS_REGION:-us-east-1} | \
  jq '.events | length' | \
  awk -v d=$days '{printf "Last %d days: %d OOMs (%.2f per day)\n", d, $1, $1/d}'
}

###############
# Claude Code #
###############

# Quick Claude on current directory
function c() {
  claude "$@"
}

# Claude with context from git diff
function cg() {
  if git diff --quiet; then
    echo "No git changes to provide as context"
    return 1
  fi
  git diff | claude "$@"
}

# Claude fix - for when tests fail
function cfix() {
  local last_cmd="${history[$((HISTCMD-1))]}"
  echo "Last command: $last_cmd"
  claude "The command '$last_cmd' failed. Fix it: $@"
}

# Claude explain - quick explanation
function cexp() {
  if [ -f "$1" ]; then
    claude "Explain this file briefly" < "$1"
  else
    claude "Explain: $@"
  fi
}

# Daily AI workflow log
function ailog() {
  local log_dir="$HOME/Repos/dot-files/.claude/logs"
  local today=$(date +%Y-%m-%d)
  local log_file="$log_dir/$today.md"

  # Create logs directory if it doesn't exist
  mkdir -p "$log_dir"

  # Create today's log from template if it doesn't exist
  if [ ! -f "$log_file" ]; then
    sed "s/\[DATE\]/$today/g" "$HOME/Repos/dot-files/.claude/ai-workflow-log-template.md" > "$log_file"
    echo "Created today's AI workflow log"
  fi

  # Open in editor
  ${EDITOR:-nvim} "$log_file"
}

#####################
# AI Pair Workflow  #
#####################

# Quick AI session (save everything, run Claude, reopen)
function ai() {
  # Check if in git repo
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "⚠️  Not in a git repository - running without safety commits"
    if [ -z "$1" ]; then
      claude
    else
      claude "$@"
    fi
    return
  fi

  # Safety commit
  echo "💾 Creating safety commit..."
  git add -A
  if git commit -m "WIP: before AI session [$(date +%H:%M)]" --no-verify 2>/dev/null; then
    echo "✓ Safety commit created"
  else
    echo "ℹ️  No changes to commit"
  fi

  # Run Claude
  echo "🤖 Starting Claude session..."
  echo ""
  if [ -z "$1" ]; then
    claude
  else
    claude "$@"
  fi

  # Show what changed
  echo ""
  echo "=== Changes from AI session ==="
  git diff HEAD~1 --stat 2>/dev/null || echo "No changes"
  echo ""
  echo "📋 Commands:"
  echo "  git diff HEAD~1  - Review all changes"
  echo "  ai-accept        - Accept with proper commit message"
  echo "  ai-undo          - Undo all AI changes"
}

# AI session with specific files as context
function aif() {
  if [ -z "$1" ]; then
    echo "Usage: aif <files...> -- <prompt>"
    echo "Example: aif src/app.js src/utils.js -- 'refactor to use async/await'"
    return 1
  fi

  # Parse files and prompt
  local files=()
  local prompt=""
  local found_separator=false

  for arg in "$@"; do
    if [ "$arg" = "--" ]; then
      found_separator=true
    elif [ "$found_separator" = true ]; then
      prompt="$prompt $arg"
    else
      files+=("$arg")
    fi
  done

  if [ ${#files[@]} -eq 0 ]; then
    echo "Error: No files specified"
    return 1
  fi

  # Safety commit
  git add -A
  git commit -m "WIP: before AI session on ${files[*]}" --no-verify 2>/dev/null

  # Run Claude with files
  claude "$prompt" "${files[@]}"

  # Show changes
  git diff HEAD~1 --stat
}

# Undo last AI session
function ai-undo() {
  local last_commit=$(git log -1 --format=%s 2>/dev/null)
  if [[ "$last_commit" =~ ^WIP:.*AI\ session ]]; then
    echo "↩️  Undoing AI session: $last_commit"
    git reset HEAD~1
    echo "✓ AI session undone"
  else
    echo "⚠️  No AI session to undo (last commit wasn't a WIP AI session)"
    echo "Last commit was: $last_commit"
  fi
}

# Accept AI changes (cleanup commit message)
function ai-accept() {
  local last_commit=$(git log -1 --format=%s 2>/dev/null)
  if [[ "$last_commit" =~ ^WIP:.*AI\ session ]]; then
    echo "✍️  What did the AI do? (commit message):"
    read -r message
    if [ -n "$message" ]; then
      git commit --amend -m "$message" --no-verify
      echo "✓ AI changes accepted with message: $message"
    else
      echo "⚠️  Empty message, keeping WIP commit"
    fi
  else
    echo "⚠️  No AI session to accept"
  fi
}

# AI session status
function ai-status() {
  local last_commit=$(git log -1 --format=%s 2>/dev/null)

  if [[ "$last_commit" =~ ^WIP:.*AI\ session ]]; then
    echo "📌 Currently in AI session"
    echo ""
    echo "Last commit: $last_commit"
    echo ""
    echo "Changes:"
    git diff HEAD~1 --stat
    echo ""
    echo "Commands:"
    echo "  ai-accept  - Accept changes and write proper commit message"
    echo "  ai-undo    - Undo AI changes completely"
    echo "  git diff HEAD~1  - Review all changes"
  else
    echo "✓ Not in AI session"
    echo "Last commit: $last_commit"
  fi
}

# Show ghelp reminder occasionally (once per day)
function _show_git_reminder() {
  local reminder_file="$HOME/.cache/git-reminder-shown"
  local today=$(date +%Y-%m-%d)

  # Create cache dir if needed
  mkdir -p "$HOME/.cache"

  # Show reminder if not shown today
  if [ ! -f "$reminder_file" ] || [ "$(cat $reminder_file 2>/dev/null)" != "$today" ]; then
    echo "$today" > "$reminder_file"
    echo ""
    echo "💡 Tip: Type 'ghelp' to see all git+Claude helper commands"
    echo ""
  fi
}

# Show reminder when entering git repos
function _git_dir_reminder() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    _show_git_reminder
  fi
}

# Hook into directory changes (if using zoxide/jump)
chpwd_functions+=(_git_dir_reminder)

source <(kubectl completion zsh)
alias k=kubectl
complete -F __start_kubectl k

source <(gh copilot alias -- zsh)

export PATH=$PATH:$HOME/Repos/dot-files/modules/node_modules/@ansible/ansible-language-server/bin
eval "$(jump shell)"
eval "$(zoxide init zsh)"

source $HOME/.zshrc_local
