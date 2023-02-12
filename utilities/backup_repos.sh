#!/bin/sh

cd Repos || exit
du -sch ./*
find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +
find . -name 'deps' -type d -prune -exec rm -rf '{}' +
find . -name '.terraform' -type d -prune -exec rm -rf '{}' +
find . -name 'ebin' -type d -prune -exec rm -rf '{}' +
find . -name '_build' -type d -prune -exec rm -rf '{}' +
find . -name '.elixir_ls' -type d -prune -exec rm -rf '{}' +
cd .. || exit

tar -zcvf "repos_backup_$(date +"%Y-%m-%d").tar.gz" ./Repos
