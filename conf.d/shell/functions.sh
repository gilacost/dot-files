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

source <(kubectl completion zsh)
alias k=kubectl
complete -F __start_kubectl k

source $HOME/.zshrc_local
