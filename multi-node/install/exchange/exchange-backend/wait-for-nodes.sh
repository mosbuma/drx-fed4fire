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
