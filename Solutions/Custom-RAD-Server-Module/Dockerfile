FROM radstudio/pa-radserver-ib:12.0

ARG password=embtdocker
ARG modulefile
ENV PA_SERVER_PASSWORD=$password

COPY $modulefile /etc/ems/module.so