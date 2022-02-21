Host HELP
==========

ASIX M06-ASO 2016-2016 @edt
---------------------------

### Help descriptiu de la creació de imatges i containers docker

 * LListar les imatges

    [host]$ docker images
    [host]$ docker images edtasixm06/*

 * Buscar imatges per repositoris externs públics

    [host]$ docker search edtasixm06
    [host]$ docker search ecanet
    [host]$ docker search ecanet
 
* Descarregar una imatge d'un repositori public

    [host]$ docker pull fedora
    [host]$ docker pull fedora:f24
    [host]$ docker pull edtasixm06/host:base
    [host]$ docker pull edtasixm06/host:latest

* Crear una imatge usant Dockerfile
    [host directori-dockerfile]$ docker build -t "<username>/<nominatge>:<tag>"
    [host directori-dockerfile]$ docker build -t "host"
    [host directori-dockerfile]$ docker build -t "host:base"
    [host directori-dockerfile]$ docker build -t "pere/host:latest"
    [host directori-dockerfile]$ docker build -t "edtasixm06/host:latest"

* Crear un container 
    [host]$ docker run --name "<nomcontainer>" -it <nomimatge> /bin/bash
    [host]$ docker run --name "host01" -it edtasixm06/host:base /bin/bash
    [host]$ docker run --name "host02" -it edtasixm06/host 








