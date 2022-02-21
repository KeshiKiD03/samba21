# Version: 0.0.1
# Dockerfile per generar una imatge base de SAMBA amb 4 shares
#FROM fedora
FROM edtasixm06/host:base
MAINTAINER @edt "ASIX M06/M11 @edt 2016-17"
# software
RUN yum -y install samba  samba-client samba-common samba-libs cifs-utils
# directoris
#RUN mkdir /opt/docker 
RUN mkdir /var/lib/samba/public /var/lib/samba/privat /var/lib/samba/test 
RUN chmod 777 /var/lib/samba/public
RUN chmod 755 /var/lib/samba/privat
# fitxers
COPY * /opt/docker/
COPY bash_profile /root/.bash_profile
COPY bashrc /root/.bashrc
COPY startup.sh /usr/sbin/
COPY smb.conf /etc/samba/
COPY *.md /var/lib/samba/public/
COPY *.md /var/lib/samba/privat/
CMD ["/bin/bash"]
EXPOSE 139 445

