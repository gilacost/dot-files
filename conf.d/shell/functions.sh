if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
  if [ -x "$(command -v nvr)" ]; then
    # alias nvim=nvr
    export EDITOR='nvr --remote-wait'
  else
    export EDITOR='echo "No nesting!"'
  fi
fi
export VISUAL=$EDITOR
alias e=$EDITOR

unsetopt BEEP

unsetopt correct

function gsina {
  git status --porcelain \
  | awk '{ if (substr($0, 0, 2) ~ /^[ ?].$/) print $0 }' \
  | peco \
  | awk '{ print "'`git rev-parse --show-toplevel`'/"$2 }'
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
  erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().'  -noshell
}

function dockerlogin {
  echo $CR_PAT | docker login ghcr.io -u gilacost --password-stdin
}

function add_asdf_plugins {
   asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
>  asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
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

source $HOME/.zshrc_local

