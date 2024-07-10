#!/bin/bash

echo "PAServer Password: securepass"
docker run -d -e CONFIG=PRODUCTION -e PA_SERVER_PASSWORD=securepass -p 80:80 -p 64211:64211 -p 3050:3050 --mount source=interbase,target=/opt/interbase --mount source=ems,target=/etc/ems pa-radserver-ib-custom-module
