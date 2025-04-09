FROM radstudio/pa-radserver-ib:12.2.1

ARG password=embtdocker
ARG modulefile
ENV PA_SERVER_PASSWORD=$password

COPY $modulefile /etc/ems/module.so