#!/bin/sh
# wait-for-nodes.sh
set -e
# wait is no longer necessary - backend polls connection now
# WAIT_S=1
#
# >&2 echo "DRX backend server - Waiting $WAIT_S seconds to allow nodes to start up"
# sleep $WAIT_S
>&2 echo "DRX backend server - starting up"

cd /etc/exchange-backend/
exec /usr/local/openjdk-8/bin/java -jar /etc/exchange-backend/clients-0.1.jar --server.port=8080 --config.rpc.host=copyright-delta-a --config.rpc.port=10006 --config.rpc.username=user1 --config.rpc.password=test --config.rpc.retryDelay=5000