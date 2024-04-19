#!/bin/bash

docker build --build-arg password=securepass \
    --tag=radstudio/pa-radserver-ib:athens \
    --tag=radstudio/pa-radserver-ib:12.0 \
    .