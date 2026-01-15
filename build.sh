#!/bin/bash

docker build --build-arg password=securepass \
    --platform linux/amd64 \
    --tag=radstudio/pa-radserver-ib:latest \
    --tag=radstudio/pa-radserver-ib:florence \
    --tag=radstudio/pa-radserver-ib:13.0 \
    .
