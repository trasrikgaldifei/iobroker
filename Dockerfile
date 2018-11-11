# DOCKERFILE for ioBroker based on Debian Stretch (slim version) and NodeJS 8

FROM debian:stretch-slim
MAINTAINER Joachim Heilig <docker@heilig.cc>
ENV DEBIAN_FRONTEND noninteractive

# Install some packages
RUN apt-get update && apt-get install -y build-essential python apt-utils curl unzip sudo wget locales apt-transport-https lsb-release build-essential libavahi-compat-libdnssd-dev libudev-dev libpam0g-dev net-tools

# Setup German locales
RUN rm -rf /var/lib/apt/lists/* && localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8
ENV LANG de_DE.utf8

# Install NodeJS 8
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs

# Install Startup Script
RUN mkdir -p /opt/scripts/ && chmod 777 /opt/scripts/
WORKDIR /opt/scripts/
ADD scripts/entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/opt/scripts/entrypoint.sh"]

# Install ioBroker
RUN mkdir -p /opt/iobroker/ && chmod 777 /opt/iobroker/
WORKDIR /opt/iobroker/
RUN npm install iobroker --unsafe-perm && echo $(hostname) >/opt/.install_host && iobroker stop && sed -i "s/$(cat /opt/.install_host)/IOBROKER_INSTALL_HOST/g" iobroker-data/objects.json && rm /opt/.install_host

# Backup ioBroker
RUN mkdir -p /opt/iobroker_install/ && chmod 777 /opt/iobroker_install/
RUN cp -R -f ./ /opt/iobroker_install/

# Prepare Backup-Directory
RUN mkdir -p /opt/iobroker_backup/ && chmod 777 /opt/iobroker_backup/

# Prepare Cronjobs
RUN mkdir -p /opt/cronjobs/ && chmod 777 /opt/cronjobs/

# Setup exposed ports and directories
VOLUME /opt/iobroker/
VOLUME /opt/iobroker_backup/
VOLUME /opt/cronjobs/
EXPOSE 8081 8082 9000 9001 2001 2002 2010 2011

ENV DEBIAN_FRONTEND teletype