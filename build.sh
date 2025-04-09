#!/bin/bash

docker build --build-arg password=securepass \
    --platform linux/amd64 \
    --tag=radstudio/pa-radserver-ib:athens \
    --tag=radstudio/pa-radserver-ib:12.2.1 \
    .
