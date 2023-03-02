#!/bin/bash

docker build --build-arg password=securepass \
    --tag=radstudio/pa-radserver-ib:latest \
    --tag=radstudio/pa-radserver-ib:alexandria \
    --tag=radstudio/pa-radserver-ib:11.3 \
    .