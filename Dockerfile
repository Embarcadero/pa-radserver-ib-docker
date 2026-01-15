FROM ubuntu:jammy
# jammy is the code name of 22.04 LTS

ARG password=embtdocker
ENV PA_SERVER_PASSWORD=$password

#INSTALL APACHE AND OTHER LIBS
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yy --no-install-recommends install \
    joe \
    wget \
    p7zip-full \
    curl \
    openssh-server \
    build-essential \
    zlib1g-dev \
    libcurl4-gnutls-dev \
    libncurses5 \
    libpython3.10 \
    apache2 \
    unzip \
    && apt-get -y autoremove \
    && apt-get -y autoclean
#====END OTHER LIBS

WORKDIR /

COPY radserver_docker.sh radserver_docker.sh

# Fix "strings: '/lib/libc.so.6': No such file"
RUN ln -s /lib/x86_64-linux-gnu/libc.so.6 /lib/libc.so.6

#====GET ZIP FILES====
ADD https://altd.embarcadero.com/getit/public/libraries/RADServer/RADServerLinux-20240402.zip ./radserver.zip
ADD https://altd.embarcadero.com/releases/studio/37.0/130/LinuxPAServer37.0.tar.gz ./paserver.tar.gz

RUN unzip radserver.zip
RUN tar xvzf paserver.tar.gz
#========END ZIP FILES

# fix "uname -a | grep Ubuntu" bug in the radserver_install.sh
RUN sed -i "s/uname -a | grep/awk -F= '\/^NAME\/\{print \$2\}' \/etc\/os-release | grep/" radserver_install.sh

# Add Interbase to /etc/services
RUN /bin/echo -e "gds-db 3050/tcp gds_db # InterBase server\n\ 
gds-db 3050/udp gds_db\n\
gds_db 3050/tcp #InterBase Server\n"\
>> /etc/services

RUN touch ./radserverlicense.slip
#Comment out the previous line and un-comment the next two to use a slip file
#COPY radserverlicense.slip ./radserverlicense.slip
#RUN chmod 644 ./radserverlicense.slip

RUN sh ./radserver_install.sh -silent

RUN mv PAServer-37.0/* .

# link to installed libpython3.10
RUN mv lldb/lib/libpython3.so lldb/lib/libpython3.so_
RUN ln -s /lib/x86_64-linux-gnu/libpython3.10.so.1 lldb/lib/libpython3.so

# Adjust configuration files
RUN \
echo "LoadModule emsserver_module /usr/lib/ems/libmod_emsserver.so" \
    > /etc/apache2/mods-available/radserver.load && \
\
/bin/echo -e "<Location /radserver>\n\
  SetHandler libmod_emsserver-handler\n\
</Location>\n" >> /etc/apache2/mods-available/radserver.conf && \
\
a2enmod radserver && \
\
echo "LoadModule emsconsole_module /usr/lib/ems/libmod_emsconsole.so" \
    > /etc/apache2/mods-available/radserverconsole.load && \
\
/bin/echo -e "<Location /radconsole>\n\
  SetHandler libmod_emsconsole-handler\n\
</Location>" >> /etc/apache2/mods-available/radserverconsole.conf && \
\
a2enmod radserverconsole

# fix "uname -a | grep Ubuntu" and "System has not been booted with systemd 
# as init system (PID 1)" bugs in the apachesetup.sh and rssetup.sh
RUN sed -i "s/uname -a | grep/awk -F= '\/^NAME\/\{print \$2\}' \/etc\/os-release | grep/" /tmp/apachesetup.sh ; \
sed -i "s/uname -a | grep/awk -F= '\/^NAME\/\{print \$2\}' \/etc\/os-release | grep/" /tmp/rssetup.sh ; \
sed -i "s/systemctl restart apache2.service/service apache2 restart/" /tmp/apachesetup.sh ; \
sed -i "s/systemctl status apache2.service --no-pager/service apache2 status/" /tmp/apachesetup.sh


#=====CLEAN UP==========
RUN rm RADServer.bin
RUN rm radserverlicense.slip
RUN rm radserver.zip
RUN rm InterBase_2020_Linux.zip
RUN rm PAServer-37.0 -r
RUN rm paserver.tar.gz
RUN rm radserver_install.sh
RUN sed -e '/apachesetup.sh/ { d; }' /tmp/linux_cleanup.sh  -i
RUN sed -e '/rssetup.sh/ { d; }' /tmp/linux_cleanup.sh  -i
RUN sh /tmp/linux_cleanup.sh
RUN echo "" > /var/www/html/index.html
#======END CLEAN UP=====

RUN service apache2 restart

# Apache
EXPOSE 80 
# PAServer
EXPOSE 64211
#Interbase
EXPOSE 3050

#need this to make the apache daemon run in foreground
#prevent container from ending when docker is started
RUN chmod +x ./radserver_docker.sh
CMD ./radserver_docker.sh
