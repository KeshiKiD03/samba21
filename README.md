# SAMBA
## @edt ASIX M06 2021-2022

Podeu trobar les imatges docker al Dockehub de [edtasixm06](https://hub.docker.com/u/edtasixm06/)

Podeu trobar la documentació del mòdul a [ASIX-M06](https://sites.google.com/site/asixm06edt/)


ASIX M06-ASO Escola del treball de barcelona

### Imatges:

* **keshikid03/samba21:base** Servidor SAMBA bàsic amb *shares* d'exemple.

* **keshikid03/samba21:base_vFinal** Servidor SAMBA bàsic amb *shares* d'exemple. Versión Final. 17.01.22


#### Execució


```
docker run --rm --name ldap.edt.org -h ldap.edt.org --net 2hisx -d keshikid03/ldap21:group

docker run --rm --name pam.edt.org -h pam.edt.prg --net 2hisx --privileged -it keshikid03/pam21:ldap /bin/bash

docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisx -p 445:445 -p 139:139 --privileged -d keshikid03/samba21:base_vFinal
```

#### INTERACTIU:
```
docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisx -p 445:445 -p 139:139 --privileged -it keshikid03/samba21:base_vFinal /bin/bash
```

 * **keshikid03/samba21:pam** Host amb un servidor samba que té usuaris unix locals, usuaris samba locals i usuaris de ldap. 
 
 A aquests usuaris de ldap se'ls crea el compte de samba (hardcoded) i el seu home.
   
   * (hardcoded: cal crear, copiar skel i assignar permisos). 
   
   Exporta els homes dels usuaris via el share *[homes]*.

==================================================================================

# SAMBA HELP KESHI
==========

FECHA 17.01.22

ASIX M06-ASO 2021-2022 @edt
---------------------------

### Cheat SHEET PRÁCTICA

1. Abrir los 3 containers (LDAP:GROUP, PAM:LDAP y SAMBA:BASE_vFinal)

2. Modificar el PAM_MOUNT.CONF.XML de PAM:LDAP y poner la IP de SAMBA --> Para que se pueda MAPEAR automáticamente la HOME del usuario SAMBA a /tmp/home/%USER/%USER

3. Verificar que podemos acceder desde el HOST de PAM:LDAP --> su -l pere --> pwd --> ls -l

---

## Pruebas LISTADO

4. Listado GUEST/ANONYMOUS (Desde SAMBA): smbclient -L [ip_samba] -> Realizamos un smbclient -L [ip_samba] de usuario GUEST. 

```
root@smb:/opt/docker# smbclient -L localhost
Enter SAMBAALONE\GUEST's password: 
Anonymous login successful

	Sharename       Type      Comment
	---------       ----      -------
	print$          Disk      Printer Drivers
	public          Disk      Public resource
	doc             Disk      Documentation
	man             Disk      Man pages
	IPC$            IPC       IPC Service (Samba 4.13.13-Debian)
SMB1 disabled -- no workgroup available
root@smb:/opt/docker# 

```

5. Listado ANONYMOUS (Desde PAM): smbclient -N -L [ip_samba] --> Podemos volver a hacer un smbclient con anonymous --> -n

```

```

6. Listado con USUARIO LDAP: smbclient -U pere -L [ip_samba]

```

```

---

### Pruebas de ACCESO

7. Accedemos al recurso DOC con el usuario PERE --> smbclient -U pere //[ip_samba]/doc

```

```

8. Acceso ANONYMOUS al recurso PUBLIC.

```
$ smbclient -N //172.19.0.4/public
Anonymous login successful
Try "help" to get a list of possible commands.
smb: \> 
```

---

### GET

* smbget smb://<IP>_<host>/<recurs>/<fitxer>

---

### MOUNT

* mount -t cifs -o <user> //<IP>/<path_origen> <destí>


---

### Nautilus

* smb://<IP>



### Help descriptiu de l'accés al servidor samba

 1. LListar els hosts de xarxa
   ```
    [container]$ smbstree
    [host]$ smbstree
   ```
 2. Llistar els dominis/workgroups existents
   ```
    [container]$ smbtree -D
    [host]$ smbtree -D
   ```
 3. Llistar els servers coneguts
   ```
    [container]$ smbtree -S
    [host]$ smbtree -S
   ```
 4. Llistar els recursos d'un servidor
   ```
    [container]$ smbclient -L nomhost
    [container]$ smbclient -L nomnetbios
    [host]$ smbclient -L nomhost
    [host]$ smbclient -L nomnetbios
   ```

 5. Connectar a recursos d'un servidor
   ```
    [container]$ smbclient //nomserver/nomrecurs [-U guest]
    [container]$ smbclient //nomserver/documentation [-U guest]
    [host]$ smbclient //nomserver/nomrecurs [-U guest]
    [host]$ smbclient //nomserver/documentation [-U guest]
   ```
 6. Descarregar un fitxer d'un recurs
   ```
    [container]$ smbget smb://nomserver/var/lib/samba/public/README.md
    [host]$ smbget smb://nomserver/var/lib/samba/public/README.md
   ```
### Connectar a recursos d'un servidor
   
 * Identificar l'adreça IP del container docker
   ``` 
    [host]$ docker inspect | grep "IPAddress"
   ```
### Resolució de noms Netbeui
   ```
    [container]$ nmblookup [-S] nomserver
    [host]$ nmblookup [-S] nomserver
   ```

Trick
=====

Per identificar clarament els servidors modificar en cada container el nom 
neybios del servidor samba, així acada container te un nom clarament diferent
dins del mateix workgroup MYGROUP

### Example:

    netbios name = Server01
 

----------------------------------------------------------------------

# 18.01.2022 - HOW TO SAMBA **[IMPORTANTE]** **AARON ANDAL**

## Global configuration

-------------------------------------------------------------------------

**OPCIONES DE CONFIGURACIÓN**


* **Netbios Name:** Es el nombre del Servidor.

* **Workgroup:** Nombre del Grupo de Trabajo o Dominio (Según Standalone o PDC).

   * Es un **NetBios** group.

   * Los hosts han de pertanecer al **mismo Workgroup/Domain** para compartir recursos SAMBA.

* **Server String:** *Descripción* del Servidor Samba.

-------------------------------------------------------------------------

**TIPOS DE ROL**

**[importante]**

* **Server Standalone:** 

* **PDC Controlador de Dominio:** Es un servidor que *controla* un DOMINIO o GRUPO de Trabajo. 

   * Es quien gestiona la **autenticación de usuarios** y **gestiona los recursos** del Dominio.

   * Red **cliente-servidor**.

* **Master Browser:** Es como el **administrador**, el que gestiona la lista de Integrantes en un **Grupo de Trabajo**. En un dominio PDC, se realiza esa función.

* **BDC:** Controlador **Secundario** de Dominio.

-------------------------------------------------------------------------

**Resolución de nombres Windows: NMB**

* **Wins support: YES** El host realiza la *resolución* de nombres.
   
   * El Servidor de **nombres Windows** (Como un DNS para nombres de Windows).

* **Wins support: NO** El host hace de **cliente Wins**.
   
   * Para identificar los nombres de otros, tiene que pedirlo al **servidor Wins**


-------------------------------------------------------------------------

* Opciones de un recurso compartido: **SHARES:** 

   * PATH **["/path/to/share"]** --> Ruta del recurso SHARE.

   * COMMENT **["comment"]** --> Comentario del recurso SHARE.

   * VOLUME **["name"]** --> Volumen del recurso SHARE.

   * READ ONLY **[yes/no]** --> Si es sólo de lectura o no

   * WRITTABLE **[yes/no]** --> Indica si se puede escribir o no



-------------------------------------------------------------------------


## Shares: Recursos de disco y de impresión

### El modelo SAMBA Client/Server de Shares



* Un **SHARE** es un recurso compartido en una red. Pueden ser:

   * De *disco*.

   * De *impresión*.

-------------------------------------------------------------------------

* Cualquier Sistema Operativo Windows, puede generar recursos compartidos.

   * Con la opción **conocida** “compartir com”.

   * Los equipos de **GNU/Linux**, utilizando SAMBA, **pueden ofrecer** recursos de **disco** e impresión.

-------------------------------------------------------------------------

* Podemos tener:

   * Un host **Windows** que ofrezca recursos de RED o Shares.

   * Un host **GNU/Linux**, ofrece recursos de RED usando el **protocolo SAMBA**.

      * Sus clientes pueden ser tanto equipos **Windows** como otros **Linux**.

-------------------------------------------------------------------------

* El **software** de SAMBA puede actuar:

   * **CLIENTE** de Recursos o SHARES de equipos que ofrece en la red (Tanto Win como Linux).

      * Órdenes como:

         * smbclient.

         * smbget.

         * mount.cifs.

         ....



   * **SERVIDOR**

      * De recursos de red, SHARES. 

         * A los que se pueden conectar otros equipos tanto **Windows** como **GNU/Linux**.

-------------------------------------------------------------------------

* SAMBA tiene funcionalidades avanzadas que permite desde Linux administrar redes Windows. Permite:

   * Actuar como **Browser** de la red.

   * Actuar como **Servidor WINS** de la red.

   * Actuar como **Server Member** de una **red Windows**.

   * Actuar como **PDC** o **Controlador principal** de Dominio de un red Windows.


-------------------------------------------------------------------------


#### El protocolo SAMBA/SMB/CIFS

**[importante]**

* **SMB**: Protocolo de Windows --> Gestión de recursos de disco e impresoras en red. 

   * Permite hacer **"compartir com"** y **"conectar unidades de red"** --> Protocolo SMB --> **Server Message Block**



* **SAMBA**: Software opensource --> Implementa el PROTOCOL SMB en equipos Linux.

   * **[SMB_es_un_protocolo_de_WINDOWS]** // **SAMBA** es un **[programa_libre_de_Linux]** que usa SMB para conectar equipos Windows].

* **CIFS**: Es una evolución de SMB. Permite compartir recursos de DISCO.

   * CIFS es **[Common_Internet_File_System]**.

   * Realiza lo mismo que SMB.


-------------------------------------------------------------------------

### Crear Shares desde Host de Windows 

* La opción "compartir com" --> Una vez compartida, otros hosts pueden acceder.

* Actualmente hay **2 modelos de seguridad de compartición** diferentes:

   * Por **[RECURSO]**: *Share Level Access Control* --> Compartir recurso a nivel de recurso:

      * Acceso **público sin seguridad**.

      * Password **genérico**, para restringir acceso.

      * Indicar si es **read/write** o solo **read only**.

      * Nombre de recurso.

      * Descripción del recurso.

   * Por **[USUARIO]**: *User Level Access Control* --> Más avanzado y completo. Permite **[establecer_una_ACL]**.

      * Nombre del recurso compartido.

      * Descripción del recurso.

      * **[Lista_de_usuarios/grupos]** y **permisos asignados a cada caso**.


* Los recursos pueden ser **públicos (browseables)** o **ocultos**.

   * Los que comiencen con **$recurso** son ocultos.


* Depende de la versión de Windows podemos.

   * Tener máximas conexiones permitidas al recurso.


-------------------------------------------------------------------------

### Conectar Shares desde Host de Windows

* Desde Windows --> Conectar una *Unidad de Red* es decir, **mapear una unidad**.

* Se asignan letras a las unidades --> **H:** a **//servidor/recurso**.

-------------------------------------------------------------------------

### Unix Clients con SAMBA

* Las órdenes principales son:

   * **[SMBTREE]**. A text based smb network browser. Obtenemos información de SAMBA en forma de **tree**

      * smbtree. 

      ```
      Enter GUEST's password:
      MYGROUP
      \\2EA1AC403693
      Samba Server Version 4.2.3
      \\2EA1AC403693\IPC$
      IPC Service (Samba Server Version 4.2.3)
      \\2EA1AC403693\public
      Share de contingut public
      \\2EA1AC403693\manpages
      Documentacio man del container
      \\2EA1AC403693\documentation
      Documentaciódoc del container
      ```

      * smbtree -D --> Obtiene el **WORKGROUP**.
     
      * smbtree -S --> Obtiene la **versión** de SAMBA.

   * **[SMBCLIENT]**. Es como un cliente FTP para acceder a los **SHARES SMB/CIFS** del **SERVIDOR**. ftp-like client to access SMB/CIFS resources on servers. Is a client that can 'talk' to an SMB/CIFS server.

      * *A service name takes the form //server/service where server is the NetBIOS name of the SMB/CIFS server offering the desired service and service is the name of the service offered*.

      **[LISTAR_MODO_USUARIO_LDAP_PERE]**

      * *smbclient -U pere -L ip_samba* --> Obtenemos un listado de **SHARES de SAMBA** con el usuario **LDAP PERE**

      ```
            $ smbclient -L smb.edt.org
      Enter WORKGROUP\pere's password: 

         Sharename       Type      Comment
         ---------       ----      -------
         print$          Disk      Printer Drivers
         public          Disk      Public resource
         doc             Disk      Documentation
         man             Disk      Man pages
         IPC$            IPC       IPC Service (Samba 4.13.13-Debian)
         pere            Disk      Home Directories
      SMB1 disabled -- no workgroup available
      $ 
      ```

      **[LISTAR_MODO_ANONYMOUS]**

      * *smbclient -N -L smb.edt.org* --> Obtenemos un listado de **SHARES de SAMBA** de forma *anónima*

      ```
      $ smbclient -N -L smb.edt.org
      Anonymous login successful

         Sharename       Type      Comment
         ---------       ----      -------
         print$          Disk      Printer Drivers
         public          Disk      Public resource
         doc             Disk      Documentation
         man             Disk      Man pages
         IPC$            IPC       IPC Service (Samba 4.13.13-Debian)
      SMB1 disabled -- no workgroup available
      $ 
      ```      

      **[LISTAR_MODO_USUARIO_IDENTIFICADO]**

      * *$ smbclient -U smbunix01 -L smb.edt.org* --> Obtenemos un listado de **SHARES de SAMBA** con el usuario *smbunix01*

      ```
      $ smbclient -U smbunix01 -L smb.edt.org
      Enter WORKGROUP\smbunix01's password: 

      	Sharename       Type      Comment
      	---------       ----      -------
      	print$          Disk      Printer Drivers
      	public          Disk      Public resource
      	doc             Disk      Documentation
      	man             Disk      Man pages
      	IPC$            IPC       IPC Service (Samba 4.13.13-Debian)
      	smbunix01       Disk      Home Directories
      SMB1 disabled -- no workgroup available
      $ 

      ```

      **[ACCESO_SESIÓN_INTERACTIVA_ANONYMOUS]** 
      
      *  *$ smbclient -N //smb.edt.org/doc* --> *Accedemos* a un recurso *DOC* de forma *anónima*

      ```
      $ smbclient -N //smb.edt.org/doc
      Anonymous login successful
      Try "help" to get a list of possible commands.
      smb: \> pwd
      Current directory is \\smb.edt.org\doc\
      smb: \> 

      ```

      **[ACCESO_SESIÓN_INTERACTIVA_PERE]**
      
      * *$ smbclient -U pere //smb.edt.org/doc* --> *Accedemos* a un recurso *DOC* con el **USUARIO LDAP PERE**

      ```
      $ smbclient -U pere //smb.edt.org/doc             
      Enter WORKGROUP\pere's password: 
      Try "help" to get a list of possible commands.
      smb: \> pwd
      Current directory is \\smb.edt.org\doc\
      smb: \> 

      ```

      **[ACCESO_SESIÓN_DESATENDIDA]**

      **[BACKUP]**

   * **[SMBGET]**. Es como WGET, permite *descargarse ficheros* de servidores *SAMBA*.

      * *smbget smb://smb.edt.org/public/uname.txt*
      
      **[SMBGET_GET_COMO_PERE]**
      
      ```
      $ smbget smb://smb.edt.org/public/uname.txt
      Password for [pere] connecting to //public/smb.edt.org: 
      Using workgroup WORKGROUP, user pere
      smb://smb.edt.org/public/uname.txt                                              
      Downloaded 104b in 1 seconds
      $ 

      ```

      **[SMBGET_GET_COMO_ANON]**
      
      ```
      $ smbget -a smb://smb.edt.org/public/uname.txt
      Using workgroup WORKGROUP, guest user
      smb://smb.edt.org/public/uname.txt                                              
      Downloaded 104b in 0 seconds
      $ 

      ```


   * **[MOUNT.CIFS]** **SÓLO ROOT PUEDE HACER MOUNT**

      * *# mount -t cifs -o guest //smb.edt.org/doc /mnt* -> Nos permite montar unidades **SHARE** con el protocolo **CIFS** a nuestro Host con **MOUNTPOINT**.

      * *# mount -t cifs*

      * *# umount /mnt* --> Desmonta **MOUNTPOINT** donde tenemos el **SHARE de SAMBA**.

      *Ejemplo*

      **[MOUNT.CIFS-GUEST]**

      ```
      root@pam:/# mount -t cifs -o guest //smb.edt.org/doc /mnt
      root@pam:/# tree /mnt
      /mnt
      |-- adduser
      |   |-- TODO
      |   |-- changelog.gz
      |   |-- copyright
      |   `-- examples
      ```

      **[MOUNT.CIFS-PERE]**

      ```
      root@pam:/# mount -v -t cifs -o user=pere,password=pere //smb.edt.org/doc /mnt
      mount.cifs kernel mount options: ip=172.19.0.4,unc=\\smb.edt.org\doc,user=pere,pass=********
      root@pam:/# tree /mnt | tail -5
         |-- changelog.Debian.gz
         |-- changelog.gz
         `-- copyright

      346 directories, 1418 files
      root@pam:/# 
      ```

      **[MOUNT.CIFS-SMBUNIX01]**

      ```
      root@pam:/# mount -v -t cifs -o user=smbunix01 //smb.edt.org/doc /mnt
      🔐 Password for smbunix01@//smb.edt.org/doc:  *********               
      mount.cifs kernel mount options: ip=172.19.0.4,unc=\\smb.edt.org\doc,user=smbunix01,pass=********
      root@pam:/# 
      ```

      *Ejemplo de /etc/fstab*

      1. *# vim /etc/fstab* --> //smb.edt.org/doc /mnt	cifs	defaults,guest,noauto	0	0

      2. mount -t cifs

      ```
      root@pam:/# mount -t cifs
      //smb.edt.org/doc on /mnt type cifs (rw,relatime,vers=3.1.1,sec=none,cache=strict,uid=0,noforceuid,gid=0,noforcegid,addr=172.19.0.4,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1)
      root@pam:/# 

      ```
   * **[FIREFOX]**
   
      * smb://mygroup

      * smb://smb.edt.org

   * **[NAUTILUS]**

      * Other Locations --> Connect to Server --> Introducir los datos de algún usuario SAMBA. 

      
   ....

   *Hay otras como...*

   * SMBPASSWD --> Permite [crear_usuarios_SAMBA].

      * smbpasswd -a [user] --> **AGREGA** un usuario Unix existente a SAMBA.

      * smbpasswd -x [user] --> **ELIMINA** un usuario.

      * smbpasswd -d [user] --> **DESACTIVA** temporalmente una cuenta de SAMBA.

      * smbpasswd -e [user] --> **REACTIVA** una cuenta de SAMBA.

      *EJEMPLO*

         1. Crear usuario Unix.
         ```
         useradd -m -s /bin/bash smbunix01
         ```

         2. Añadirle contraseña a usuario Unix.
         ```
         echo -e "smbunix01\nsmbunix01\n" | passwd smbunix01
         ```

         3. Convertirlos en USUARIOS SAMBA.
         
         *Interactivo*
         ```
         smbasswd -a smbunix01
         ```
         *Desatendido*
         ```
         echo -e "smbunix01\nsmbunix01\n" | smbpasswd -a smbunix01

         root@smb:/opt/docker# echo -e "smbunix01\nsmbunix01\n" | smbpasswd -a smbunix01
         New SMB password:
         Retype new SMB password:
         Added user smbunix01.

         ```
         4. Verificamos.
         ```
         root@smb:/opt/docker# pdbedit -L
         pere:5001:Pere Pou
         anna:5002:Anna Pou
         jordi:5004:Jordi Mas
         marta:5003:Marta Mas
         pau:5000:Pau Pou
         smbunix01:1000:
         root@smb:/opt/docker# 

         ```

   * SMBCONTROL

   * SMBCQUOTAS

   * SMBCACLS

   * SMBCLIENT4

   * SMBSPOOL



* Podemos acceder a **RECURSOS SAMBA** con herramientas GRÁFICAS como *FIREFOX o NAUTILUS*

* 

#### SMBCLIENT

#### SMBTREE

#### SMBGET

#### MOUNT.CIFS

#### FIREFOX

#### NAUTILUS

### Unix Server con SAMBA

#### Ejemplo de configuración Server Shares

#### Instalación

------------------------------------------------------------------------

### Name Resolution

#### Resolución Hosts Clientes de Windows

##### Utilización de Imhosts

##### Utilización Wins

#### Reslución Hosts Clientes de GNU/Linux 

#### El servicio nmbd

### Master Browser

#### Primer Caso 

#### Segundo Caso

#### Tercer Caso

### Domain Master Browser

## Users / Groups (Share Options) Security

### Users / Groups

#### SMBPASSWD 

#### Ejemplos de validación de Usuarios

##### Ejemplo 1:

##### Ejemplo 2:

##### Ejemplo 3:

##### Ejemplo 4:

##### Ejemplo 5:

##### Ejemplo 6:

##### Ejemplo 7:

#### Ejemplo de lectura / escritura / mode

##### Ejemplo 8:

##### Ejemplo 9:

##### Ejemplo 10:

##### Ejemplo 11:

##### Ejemplo 12:

### Security

#### Repaso al modelo de trabajo

### Directorio Home de los usuarios

#### ¡Una mala forma de trabajar!

#### Exportar los Homes de los usuarios (una buena forma de trabajar)

## Global Options

### General

### Hosts Allow/Deny

### Logging

## Roles del servidor SAMBA

### Roles

#### Role Standalone

#### Role PDC Domain Server

## Repaso de órdenes CLIENTE

### SMBCLIENT

#### Usuarios autenticados

#### Órdenes desatendidas

#### Shares Backups

### CIFS - SMBFS

#### Múltiples Samba Servers

## Prácticas

### Práctica 1: Homes Samba

### Práctica 2: LDAP + SAMBA + PAM

## Práctica: SAMBA + LDAP + PAM