#!/bin/bash

docker run -d -e CONFIG=INTERBASE -p 3050:3050 --mount source=interbase,target=/opt/interbase --mount source=ems,target=/etc/ems  radstudio/pa-radserver-ib