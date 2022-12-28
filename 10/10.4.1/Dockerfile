FROM ubuntu:bionic

ARG password=embtdocker

ENV PA_SERVER_PASSWORD=$password

COPY radserver_docker.sh ./radserver_docker.sh

RUN echo "gds-db 3050/tcp gds_db # InterBase server" >> /etc/services
RUN echo "gds-db 3050/udp gds_db" >> /etc/services
RUN echo "gds_db 3050/tcp #InterBase Server" >> /etc/services

#INSTALL APACHE AND OTHER LIBS
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -yy install --no-install-recommends \
    apache2 \
    unzip \
    xorg libgl1-mesa-dev libosmesa-dev libgtk-3-bin build-essential \
    libcurl3 libcurl-openssl1.0-dev \
    && apt-get -y autoremove \
    && apt-get -y autoclean
#====END OTHER LIBS

#====GET ZIP FILES====
ADD https://altd.embarcadero.com/releases/studio/21.0/1/RADServerInstallerLinux.1.zip ./radserver.zip
ADD https://altd.embarcadero.com/releases/studio/21.0/1/PAServer/LinuxPAServer21.0.tar.gz ./paserver.tar.gz

RUN unzip radserver.zip
RUN tar xvzf paserver.tar.gz
#========END ZIP FILES

RUN touch ./radserverlicense.slip
#Comment out the previous line and un-comment the next two to use a slip file
#COPY radserverlicense.slip ./radserverlicense.slip
#RUN chmod 644 ./radserverlicense.slip

RUN sh ./radserver_install.sh -silent

RUN mv PAServer-21.0/* .

RUN echo "LoadModule emsserver_module /usr/lib/ems/libmod_emsserver.so" > /etc/apache2/mods-available/radserver.load
RUN echo "<Location /radserver>" > /etc/apache2/mods-available/radserver.conf
RUN echo "  SetHandler libmod_emsserver-handler" >> /etc/apache2/mods-available/radserver.conf
RUN echo "</Location>" >> /etc/apache2/mods-available/radserver.conf
RUN a2enmod radserver
RUN echo "LoadModule emsconsole_module /usr/lib/ems/libmod_emsconsole.so" > /etc/apache2/mods-available/radserverconsole.load
RUN echo "<Location /radconsole>" > /etc/apache2/mods-available/radserverconsole.conf
RUN echo "  SetHandler libmod_emsconsole-handler" >> /etc/apache2/mods-available/radserverconsole.conf
RUN echo "</Location>" >> /etc/apache2/mods-available/radserverconsole.conf
RUN a2enmod radserverconsole

#=====CLEAN UP==========
RUN rm RADServer.bin
RUN rm radserverlicense.slip
RUN rm radserver.zip
RUN rm InterBase_2020_Linux.zip
RUN rm PAServer-21.0 -r
RUN rm paserver.tar.gz
RUN rm radserver_install.sh
RUN sed -e '/apachesetup.sh/ { d; }' /tmp/linux_cleanup.sh  -i
RUN sed -e '/rssetup.sh/ { d; }' /tmp/linux_cleanup.sh  -i
RUN sh /tmp/linux_cleanup.sh
RUN echo "" > /var/www/html/index.html
#======END CLEAN UP=====

RUN service apache2 restart

EXPOSE 80 
EXPOSE 64211
EXPOSE 8082
EXPOSE 3050

#need this to make the apache daemon run in foreground
#prevent container from ending when docker is started
RUN chmod +x ./radserver_docker.sh
CMD ./radserver_docker.sh
