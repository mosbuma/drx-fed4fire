#!/bin/sh
# wait-for-nodes.sh
set -e
WAIT_S=180
  
>&2 echo "DRX backend server - Waiting $WAIT_S seconds to allow nodes to start up"
sleep $WAIT_S
>&2 echo "DRX backend server - starting up"
# - server.port=8080
# - config.rpc.host=0.0.0.0
# - config.rpc.port=10006
# - config.rpc.username=user1
# - config.rpc.password=test

cd /etc/exchange-backend/
exec /usr/local/openjdk-8/bin/java -jar /etc/exchange-backend/clients-0.1.jar --server.port=8080 --config.rpc.host=192.168.3.1 --config.rpc.port=10001 --config.rpc.username=user1 --config.rpc.password=test