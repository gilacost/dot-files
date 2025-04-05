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

function gsina {
  git status --porcelain \
  | awk '{ if (substr($0, 0, 2) ~ /^[ ?].$/) print $0 }' \
  | peco \
  | awk '{ print "$(git rev-parse --show-toplevel)/"$2 }'
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

function rebuild_nix {
  set -x
  darwin-rebuild build --flake "./#$1"
  darwin-rebuild switch --flake "./#$1"
  set +x
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

fetc

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

function gcai() {
  # Check if there are staged changes (excluding lock files)
  if ! git diff --staged --quiet; then
      # Generate commit message using OpenAI API via sc
      COMMIT_MESSAGE=$(git diff --staged -- . ":(exclude)mix.lock" ":(exclude)package-lock.json" ":(exclude)yarn.lock" ":(exclude)pnpm-lock.yaml" | sc --api openai "summarize changes as a commit message, make it short and descriptive, andproperly formatted")
  
      # Trim leading/trailing spaces
      COMMIT_MESSAGE=$(echo "$COMMIT_MESSAGE" | sed 's/^ *//;s/ *$//')
  
      # Ensure the commit message is not empty
      if [[ -n "$COMMIT_MESSAGE" ]]; then
          git commit -m "$COMMIT_MESSAGE"
          echo "Committed with message: $COMMIT_MESSAGE"
      else
          echo "Error: Generated commit message is empty."
          exit 1
      fi
  else
      echo "No staged changes to commit (or only lock files were changed)."
  fi
}

function gbai() {
  # Check if there are staged changes
  if ! git diff --staged --quiet; then
      # Generate branch name using OpenAI API via sc
      BRANCH_NAME=$(git diff --staged | sc --api openai "summarize changes as a short and descriptive branch name, use-kebab-case")
  
      # Trim leading/trailing spaces and replace spaces with dashes
      BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/^ *//;s/ *$//' | tr ' ' '-')
  
      # Ensure the branch name is not empty
      if [[ -n "$BRANCH_NAME" ]]; then
          git checkout -b "$BRANCH_NAME"
          echo "Switched to new branch: $BRANCH_NAME"
      else
          echo "Error: Generated branch name is empty."
          exit 1
      fi
  else
      echo "No staged changes to create a branch."
  fi
}

function prdai() {
  # Define the base branch (default to 'main' or set it as an argument)
  BASE_BRANCH=${1:-main}
  
  # Get the current branch
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  
  # Ensure we're not on the base branch
  if [ "$CURRENT_BRANCH" = "$BASE_BRANCH" ]; then
      echo "You are on the $BASE_BRANCH branch. Switch to a feature branch before generating a PR description."
      exit 1
  fi
  
  # Ensure the base branch exists locally; fetch if necessary
  if ! git show-ref --quiet "refs/heads/$BASE_BRANCH"; then
      echo "Base branch $BASE_BRANCH not found locally. Fetching..."
      git fetch origin "$BASE_BRANCH:$BASE_BRANCH"
  fi
  
  # Generate the PR description by comparing the current branch to the base branch
  PR_DESCRIPTION=$(git diff "$BASE_BRANCH"..."$CURRENT_BRANCH" -- . ":(exclude)mix.lock" ":(exclude)package-lock.json" ":(exclude)yarn.lock" ":(exclude)pnpm-lock.yaml" | sc --api openai "summarize changes in a detailed pull request description")
  
  # Trim leading/trailing spaces
  PR_DESCRIPTION=$(echo "$PR_DESCRIPTION" | sed 's/^ *//;s/ *$//')
  
  # Ensure the PR description is not empty
  if [[ -n "$PR_DESCRIPTION" ]]; then
      echo "Generated PR Description:"
      echo "--------------------------------------"
      echo "$PR_DESCRIPTION"
      echo "--------------------------------------"
  else
      echo "Error: Generated PR description is empty."
      exit 1
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

source <(kubectl completion zsh)
alias k=kubectl
complete -F __start_kubectl k

source <(gh copilot alias -- zsh)

export PATH=$PATH:$HOME/Repos/dot-files/modules/node_modules/@ansible/ansible-language-server/bin
eval "$(jump shell)"

source $HOME/.zshrc_local
