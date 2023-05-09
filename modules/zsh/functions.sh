if [ -x "$(command -v nvr)" ]; then
  # alias nvim=nvr
  export EDITOR='nvr --remote-wait'
else
  export EDITOR='echo "No nesting!"'
fi
export VISUAL=$EDITOR
alias e=$EDITOR

# # rust avoid
# # linking with cc failed
# # note: ld: library not found for -lSystem
# # https://github.com/TimNN/cargo-lipo/issues/41
# SDKROOT=`xcrun --sdk macosx --show-sdk-path`;
# export LIBRARY_PATH="$SDKROOT/usr/lib";

unsetopt BEEP

unsetopt correct

function gsina {
  git status --porcelain \
  | awk '{ if (substr($0, 0, 2) ~ /^[ ?].$/) print $0 }' \
  | peco \
  | awk '{ print "'`git rev-parse --show-toplevel`'/"$2 }'
}

function service_port {
  sudo netstat -tulnp
}

function rm_pattern {
  # removes nested folders of $1=pattern, e.g "_build"
  find . -type d -name "$1" -exec rm -rf {} +
}

function update_input {
  nix flake lock --update-input ${1:"nixpkgs"}
}

function checkports_host {
  sudo nmap -sTU -O $1
}

    ### yaml for image  kubectl run kiada --image=luksa/kiada:0.1 --dry-run=client -o yaml > mypod.yaml
# kubectl run --image=tutum/curl -it --restart=Never --rm client-pod curl 10.244.2.4:8080

function ctdeps {
  mix xref graph --sink $1 --only-nodes
}

function depstree {
  mix xref graph --sink $1
}

function rebuild_nix {
  darwin-rebuild build --flake ./\#$1
  darwin-rebuild switch --flake ./\#$1
}

function depstreefilter {
  # Filters deps tree. Defaults to compile
  # which will only list the transitive deps
  # compile should be default
  mix xref graph --sink $1 --label $2
}

function depsgraph {
  mix xref graph --format stats
}

function poyamlfimg {
  kubectl run kiada --image=$1 --dry-run=client -o yaml > $2.yaml
}

function insidecurl {
  kubectl run --image=praqma/network-multitool:alpine-extra -it --restart=Never --rm client-pod curl $1
}

function erlv {
  cat $(dirname $(dirname $(which erl)))/lib/erlang/releases/**/OTP_VERSION
}

function dockerlogin {
  echo $CR_PAT | docker login ghcr.io -u gilacost --password-stdin
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
    ${EDITOR:-vim} default.nix
  fi
}

flakifiy() {
  if [ ! -e flake.nix ]; then
    nix flake new -t github:nix-community/nix-direnv .
  elif [ ! -e .envrc ]; then
    echo "use flake" > .envrc
    direnv allow
  fi
  ${EDITOR:-vim} flake.nix
}

source <(kubectl completion zsh)
alias k=kubectl
complete -F __start_kubectl k

export PATH=$PATH:$HOME/Repos/dot-files/modules/node_modules/@ansible/ansible-language-server/bin



source $HOME/.zshrc_local
