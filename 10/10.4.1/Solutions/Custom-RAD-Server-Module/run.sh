#!/bin/bash

echo "PAServer Password: securepass"
docker run -it -e PA_SERVER_PASSWORD=securepass \
    -p 80:80 -p 64211:64211 -p 8082:8082 -p 3050:3050 \
    --mount type=volume,source=interbase,target=/opt/interbase \
    --mount type=volume,source=ems,target=/etc/ems \
    pa-radserver-ib-custom-module:10.4.1 `#/bin/sh`