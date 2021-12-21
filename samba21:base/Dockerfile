# Version: 0.0.1
# @edt M06 2019-2020
# samba
# -------------------------------------
FROM debian:latest
LABEL author="@isx25633105 ASIX M06-ASO"
LABEL description="SAMBA server 2021"
RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y procps samba samba-client vim finger passwd nmap
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/install.sh /opt/docker/startup.sh
WORKDIR /opt/docker
CMD ["/opt/docker/startup.sh"]
