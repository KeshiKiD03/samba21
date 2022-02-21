# Version: 0.0.1
# Dockerfile per generar una imatge host base amb utilitats GNU/linux
FROM fedora
MAINTAINER @edt "ASIX M06/M11 @edt 2015-16"
# software
RUN yum -y install vim nmap procps psmisc iproute iputils tree passwd less 
# directoris
RUN mkdir /opt/docker 
# fitxers
COPY * /opt/docker/
COPY bash_profile /root/.bash_profile
COPY bashrc /root/.bashrc
COPY startup.sh /usr/sbin/
CMD ["/bin/bash"]
