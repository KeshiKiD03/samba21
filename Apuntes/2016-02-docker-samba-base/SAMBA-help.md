SAMBA HELP
==========

ASIX M06-ASO 2015-2016 @edt
---------------------------

### Help descriptiu de l'accés al servidor samba

 * LListar els hosts de xarxa


    [container]$ nmblookup [-S] nomserver
    [host]$ nmblookup [-S] nomserver

 * Llistar els dominis/workgroups existents


    [container]$ smbtree -D
    [host]$ smbtree -D

 * Llistar els servers coneguts


    [container]$ smbtree -S
    [host]$ smbtree -S

 * Llistar els recursos d'un servidor


    [container]$ smbclient -L nomhost
    [container]$ smbclient -L nomnetbios
    [host]$ smbclient -L nomhost
    [host]$ smbclient -L nomnetbios

 * Connectar a recursos d'un servidor


    [container]$ smbclient //nomserver/nomrecurs [-U guest]
    [container]$ smbclient //nomserver/documentation [-U guest]
    [host]$ smbclient //nomserver/nomrecurs [-U guest]
    [host]$ smbclient //nomserver/documentation [-U guest]

 * Descarregar un fitxer d'un recurs


    [container]$ smbget smb://nomserver/var/lib/samba/public/README.md
    [host]$ smbget smb://nomserver/var/lib/samba/public/README.md

### Connectar a recursos d'un servidor

 * Identificar l'adreça IP del container docker

    
    [host]$ docker inspect | grep "IPAddress"

### Resolució de noms Netbeui

    [container]$ nmblookup [-S] nomserver
    [host]$ nmblookup [-S] nomserver


Trick
=====

Per identificar clarament els servidors modificar en cada container el nom 
neybios del servidor samba, així acada container te un nom clarament diferent
dins del mateix workgroup MYGROUP

### Example:

    netbios name = Server01
 
