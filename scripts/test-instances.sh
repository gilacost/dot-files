INVENTORY="website-production-1"

HOSTS=$(aws ec2 describe-instances --filters "Name=tag:Inventory,Values=${INVENTORY}" --output text --query 'Reservations[*].Instances[*].PublicIpAddress')

while read -r HOST; do
  if curl -s -m 1 --connect-timeout 1 -H "x-forwarded-proto: https" -H "host: thebookofeveryone.com" ${HOST}:80/uk > /dev/null
  then
    echo "\033[0;32m$HOST instance is up"
  else
    echo "\033[0;31m$HOST instance is down"
    ssh -i ~/.ssh/tboe-us-east.pem ubuntu@$HOST "
    sudo service docker restart
    sleep 1
    docker start elixir_spike_1 elixir_phoenix_1
    "
  fi
done <<< "$HOSTS"
