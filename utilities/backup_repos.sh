#!/bin/sh

du -sch ./*
find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +
find . -name 'deps' -type d -prune -exec rm -rf '{}' +
find . -name '.terraform' -type d -prune -exec rm -rf '{}' +
find . -name 'ebin' -type d -prune -exec rm -rf '{}' +
find . -name '_build' -type d -prune -exec rm -rf '{}' +
find . -name '.elixir_ls' -type d -prune -exec rm -rf '{}' +

# to review
# 4.0K    ./GREECE.md
# 25M     ./alvivis_dotfiles
# 11M     ./assessments
# 18M     ./aws
# 68M     ./beamops
# 68M     ./dot-files
# 307M    ./pipoti
# 39M     ./programming_phoenix_live_view
# 176M    ./rethinkingdevops
# 35M     ./strava_scrape
# 14M     ./strava_sync
# 27M     ./super-linter
# 971M    total

tar -zcvf "repos_backup_$(date +"%Y-%m-%d").tar.gz" ./Repos
