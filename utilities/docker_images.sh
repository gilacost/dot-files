#!/bin/bash

if [ $# -lt 1 ]
then
cat << HELP

dockertags  --  list all tags for a Docker image on a remote registry.

EXAMPLE: 
    - list all tags for hexpm/elixir:
       dockertags hexpm/elixir

    - list all hexpm/elixir tags at page 2:
       dockertags hexpm/elixir 2

HELP
fi

IMAGE="$1"
PAGE="${2-1}"
# hexpm/elixir

curl -L -s "https://hub.docker.com/v2/repositories/${IMAGE}/tags/?page_size=1024&page=${PAGE}&name&ordering" |jq '."results"[]["name"]'
