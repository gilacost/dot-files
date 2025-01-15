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

function image_tags {
  curl -s "https://registry.hub.docker.com/v2/repositories/$1/tags/?page_size=${2:-200}" | jq -r '.results[].name'
}

function dockerlogin {
  echo $CR_PAT | docker login ghcr.io -u gilacost --password-stdin
}

function gcai() {
  if git diff --staged | grep -q '.'; then
    local staged_diff
    local payload
    local response
    local commit_message

    # Capture the staged diff
    staged_diff=$(git diff --cached --no-ext-diff --diff-filter=AM)

    if [[ -z "$staged_diff" ]]; then
      echo "No textual changes staged for commit message generation."
      return 1
    fi

    # Escape the diff for JSON
    staged_diff=$(echo "$staged_diff" | jq -Rs .)

    # Generate JSON payload for the OpenAI API
    payload=$(jq -n \
      --arg model "gpt-3.5-turbo" \
      --arg content "Generate a concise and descriptive commit message based on the following Git diff:\n\n$staged_diff" \
      '{model: $model, messages: [{role: "user", content: $content}]}')

    # Send the request to the OpenAI API
    response=$(curl -s -X POST https://api.openai.com/v1/chat/completions \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -d "$payload")

    # Debug: Print the response for troubleshooting (optional)
    # echo "$response"

    # Extract the AI's response for the commit message
    commit_message=$(echo "$response" | jq -r '.choices[0].message.content // empty')

    if [ -z "$commit_message" ]; then
      echo "Failed to generate a commit message. Please check the API response."
      return 1
    fi

    # Perform the commit
    echo "Generated Commit Message:"
    echo "$commit_message"
    echo

    git commit -m "$commit_message"
  else
    echo "No changes staged for commit message generation."
  fi
}

function gbai() {
  if git diff --staged | grep -q '.'; then
    local staged_files
    local response
    local branch_name

    # Capture the list of staged files
    staged_files=$(git diff --cached --name-only)

    if [ -z "$staged_files" ]; then
      echo "No staged changes to generate a branch name."
      exit 1
    fi

    # Escape newline characters in staged files for JSON
    staged_files=$(echo "$staged_files" | jq -Rsa .)

 # Escape and format staged files for JSON
    staged_files=$(echo "$staged_files" | jq -Rsa .)

    # Define the JSON payload with properly formatted content
    payload=$(jq -n \
      --arg model "gpt-3.5-turbo" \
      --arg content "Generate a concise and descriptive Git branch name based on these staged files: $staged_files" \
      '{model: $model, messages: [{role: "user", content: $content}]}')


# Send the request to the OpenAI API
    response=$(curl -s -X POST https://api.openai.com/v1/chat/completions \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -d "$payload")

    # Debug: Print the response for troubleshooting
    # echo "$response"

    # Extract the AI's response for the branch name
    branch_name=$(echo "$response" | jq -r '.choices[0].message.content // empty' | tr -d '\n' | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')

    if [ -z "$branch_name" ]; then
      echo "Failed to generate a branch name. Please check the API response."
      return 1
    fi

    # Create and switch to the new branch
    echo "Creating and switching to branch: $branch_name"
    git checkout -b "$branch_name"
  else
    echo "No changes staged for branch generation."
  fi
}

function prdai() {
  local base_branch=${1:-main}  # Default to "main" if no argument is provided
  local current_branch
  local branch_diff
  local payload
  local response
  local pr_description

  # Get the current branch name
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  if [ "$current_branch" = "$base_branch" ]; then
    echo "You are on the $base_branch branch. Switch to a feature branch before generating a PR description."
    return 1
  fi

  # Ensure the base branch exists locally
  if ! git show-ref --quiet "refs/heads/$base_branch"; then
    echo "Base branch $base_branch not found locally. Fetching..."
    git fetch origin "$base_branch:$base_branch"
  fi

  # Generate the diff between the current branch and the base branch
  branch_diff=$(git diff "$base_branch...$current_branch" --no-ext-diff --diff-filter=AM)

  if [ -z "$branch_diff" ]; then
    echo "No changes detected between $current_branch and $base_branch for PR description generation."
    return 1
  fi

  # Sanitize the diff for JSON by escaping control characters
  branch_diff=$(printf "%s" "$branch_diff" | sed -e 's/[\x00-\x1F\x7F]//g' -e 's/\r//g' | jq -Rs .)

  # Generate JSON payload for the OpenAI API
  payload=$(jq -n \
    --arg model "gpt-3.5-turbo" \
    --arg content "Generate a detailed pull request description in markdown format based on the following Git diff\n\n$branch_diff. Please return the content between markdown backticks" \
    '{model: $model, messages: [{role: "user", content: $content}]}')

  # Send the request to the OpenAI API
  response=$(curl -s -X POST https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$payload")

  # Debug: Print the response for troubleshooting (optional)
  echo "$response"

  # Extract the AI's response for the PR description
  pr_description=$(echo "$response" | sed -n '/```markdown/,/```/p' | sed '1d;$d')

  if [ -z "$pr_description" ]; then
    echo "Failed to generate a PR description. Please check the API response."
    return 1
  fi

  # Output the PR description
  echo "Generated Pull Request Description:"
  echo "$pr_description"
  echo

  # Optionally, copy the description to the clipboard
  echo "$pr_description" | pbcopy  # macOS (replace with xclip for Linux)
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
