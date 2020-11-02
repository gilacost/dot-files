#!/usr/bin/env bash

function log () {
    printf "%s %s\n" "->" "$1"
}

log "Updating all asdf-plugin remotes..."

asdf plugin update --all

log "Updating each plugin reference to the latest revision..."

log "Done, bye! 👋"
