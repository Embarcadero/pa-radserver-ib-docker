#!/bin/bash
if [ "$1" == '' ]; then
    echo "RAD Server Docker configuration script";
    echo "Required argument: id or name of running pa-radserver-ib-custom-module container";
    echo "ex: config.sh elegant_shaw";
else
    docker exec -it $1 sh -c "apt-get update && apt-get install -y nano ; nano /etc/ems/emsserver.ini; service apache2 restart"
fi