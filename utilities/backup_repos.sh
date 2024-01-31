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
    --exclude '*.iso' \
    --exclude '*.msi' \
    --exclude '*.next' \
    --exclude '.devenv' \
    --exclude 'PerBook' \
    --exclude '_build' \
    --exclude Common \
    --exclude 'nixos.qcow2' \
    --exclude-vcs \
    ./Repos 
