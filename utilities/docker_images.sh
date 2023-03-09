#!/bin/bash

if [ $# -lt 1 ]
then
cat << HELP

dockertags  --  list all tags for a Docker image on a remote registry.

EXAMPLE: 
    - list all tags for ubuntu:
       dockertags ubuntu

    - list all php tags containing apache:
       dockertags php apache

HELP
fi

image="$1"

curl 'https://hub.docker.com/v2/repositories/hexpm/elixir/tags/?page_size=1024&page&name&ordering' |jq '."results"[]["name"]'
