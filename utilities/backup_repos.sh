#!/bin/sh

cd ~/Repos || exit
du -sch ./*
cd .. || exit

tar -zcvf  "repos_backup_$(date +"%Y-%m-%d").tar.gz" \
    --exclude node_modules \
    --exclude deps \
    --exclude '.terraform' \
    --exclude ebin \
    --exclude _ebuild \
    --exclude '.elixir_ls' \
    --exclude 'PerBook' \
    --exclude Common \
    --exclude-vcs \
    ./Repos 
