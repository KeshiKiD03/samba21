# samba21:pam
FROM debian:latest
LABEL version="1.0"
LABEL author="@isx25633105 ASIX-M06"
LABEL subject="samba host"
RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install procps samba samba-client iproute2 tree nmap vim less finger passwd libpam-pwquality libpam-mount libnss-ldapd libpam-ldapd nslcd nslcd-utils ldap-utils 
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/install.sh /opt/docker/startup.sh
WORKDIR /opt/docker
CMD /opt/docker/startup.sh
