#!/bin/bash

docker build . --build-arg password=securepass \
    --tag=radstudio/pa-radserver-ib:10.4.1 --tag=radstudio/pa-radserver-ib:sydney