FROM radstudio/pa-radserver-ib:latest

ARG password=embtdocker
ARG modulefile
ENV PA_SERVER_PASSWORD=$password

COPY $modulefile /etc/ems/module.so