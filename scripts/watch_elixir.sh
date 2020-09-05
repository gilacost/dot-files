fswatch --latency=0.01 --one-per-batch lib/ test/ | MIX_ENV=test mix do test --stale, run --no-halt -e "IO.gets(:stdio, ''); IO.puts 'Restarting...'; :init.restart()"
