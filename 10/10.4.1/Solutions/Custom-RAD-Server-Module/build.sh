#!/bin/bash

if [ "$1" == '' ]; then
    echo "RAD Server Docker pa-radserver-ib-custom-module Build Script";
    echo "Place RAD Server endpoint custom resource module in this directory and pass it as the first argument.";
    echo "Required argument: module filename";
    echo "ex: build.sh bplProject1.so";
else
    if [ -e ./$1 ]; then
        docker build . --build-arg password=securepass --build-arg modulefile=$1 \
            -t pa-radserver-ib-custom-module:10.4.1 --no-cache
    else
        echo "The RAD Server endpoint custom resource module needs to be in this directory.";
    fi
fi

