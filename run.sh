#!/bin/bash

echo "PAServer Password: securepass"
docker run  --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
    -it -e PA_SERVER_PASSWORD=securepass \
    -p 80:80 -p 64211:64211 -p 3050:3050 \
    --mount source=interbase,target=/opt/interbase \
    --mount source=ems,target=/etc/ems  \
    --platform linux/amd64 \
    radstudio/pa-radserver-ib:12.2.1
