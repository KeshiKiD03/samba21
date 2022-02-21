# Version: 0.0.1
FROM fedora
MAINTAINER @edt "ASIX M06/M11 @edt 2015-16"
# software
RUN yum -y install samba-client samba-common samba-libs samba cifs-utils
# directoris
RUN mkdir /opt/docker
RUN mkdir /var/lib/samba/public
RUN mkdir /var/lib/samba/test
RUN mkdir /var/lib/samba/testro
RUN mkdir /var/lib/samba/testrw
RUN chmod 755 /var/lib/samba/testro
RUN chmod 777 /var/lib/samba/testrw
# fitxers
COPY * /opt/docker/
COPY .* /opt/docker/
COPY .bash_profile /root/
COPY .bashrc /root/
COPY startup.sh /usr/sbin/
COPY smb.conf /etc/samba/
COPY *.md /var/lib/samba/public/
CMD ["/bin/bash"]
EXPOSE 139 445

