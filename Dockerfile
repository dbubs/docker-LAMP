FROM greyltc/archlinux:2016-01-24
MAINTAINER Grey Christoforo <grey@christoforo.net>

RUN pacman -Syyu --noconfirm --noprogressbar reflector
RUN reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist

ADD setupApacheSSLKey.sh /usr/sbin/setup-apache-ssl-key

ENV DO_SSL_SELF_GENERATION true
ENV SUBJECT /C=US/ST=CA/L=CITY/O=ORGANIZATION/OU=UNIT/CN=localhost

ADD install-lamp.sh /usr/sbin/install-lamp
RUN install-lamp

# expose web server ports
EXPOSE 80
EXPOSE 443

VOLUME /root/sslKeys

# set some default variables for the startup script
ENV DO_SSL_SELF_GENERATION false
ENV DO_SSL_LETS_ENCRYPT_FETCH false
ENV EMAIL fail
ENV START_APACHE true
ENV START_MYSQL true
ENV START_POSTGRESQL flase
ENV ENABLE_DAV false

# start servers
ADD startServers.sh /usr/sbin/start-servers
CMD start-servers && sleep infinity
