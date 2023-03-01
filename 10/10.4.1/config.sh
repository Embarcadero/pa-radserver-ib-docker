#!/bin/bash

if [ "$1" == '' ]; then
    echo "RAD Server Docker pa-radserver-ib Configure Script";
    echo "Required arguments: container hash or name";
    echo "ex: config.sh gracious_galois";
else
    docker exec -it $1 sh -c "apt-get update && apt-get install -y nano ; nano /etc/ems/emsserver.ini; service apache2 restart"
fi
