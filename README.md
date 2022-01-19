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


<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/KESHI-SAMBA-HOST.png" />


# SAMBA HELP KESHI
==========

FECHA 17.01.22

ASIX M06-ASO 2021-2022 @edt
---------------------------

### Cheat SHEET PRÁCTICA

1. Abrir los 3 containers (LDAP:GROUP, PAM:LDAP y SAMBA:BASE_vFinal)

2. Modificar el PAM_MOUNT.CONF.XML de PAM:LDAP y poner la IP de SAMBA --> Para que se pueda MAPEAR automáticamente la HOME del usuario SAMBA a /tmp/home/%USER/%USER

3. Verificar que podemos acceder desde el HOST de PAM:LDAP --> su -l pere --> pwd --> ls -l

<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/HECHO.PNG" />

<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/HECHO_1.PNG" />

<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/HECHO_2.PNG" />

<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/HECHO_3.PNG" />

==========

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
      <img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/SMBCLIENT-ANON.png" />    

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

      <img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/SMBCLIENT%20-%20ACCESO%20-%20PERE.png" />    

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

      <img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/SMBGET%20-%20PERE.png" />    

      **[SMBGET_GET_COMO_ANON]**
      
      ```
      $ smbget -a smb://smb.edt.org/public/uname.txt
      Using workgroup WORKGROUP, guest user
      smb://smb.edt.org/public/uname.txt                                              
      Downloaded 104b in 0 seconds
      $ 

      ```

      <img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/SMBGET%20-%20ANON.png" />    


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

      <img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/MOUNT%20-%20PERE.png" />     

      **[MOUNT.CIFS-SMBUNIX01]**

      ```
      root@pam:/# mount -v -t cifs -o user=smbunix01 //smb.edt.org/doc /mnt
      🔐 Password for smbunix01@//smb.edt.org/doc:  *********               
      mount.cifs kernel mount options: ip=172.19.0.4,unc=\\smb.edt.org\doc,user=smbunix01,pass=********
      root@pam:/# 
      ```

      <img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/MOUNT-CIFS.png" />      

      *Ejemplo de /etc/fstab*

      1. *# vim /etc/fstab* --> //smb.edt.org/doc /mnt	cifs	defaults,guest,noauto	0	0

      2. mount -t cifs

      ```
      root@pam:/# mount -t cifs
      //smb.edt.org/doc on /mnt type cifs (rw,relatime,vers=3.1.1,sec=none,cache=strict,uid=0,noforceuid,gid=0,noforcegid,addr=172.19.0.4,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1)
      root@pam:/# 

      ```

      <img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/MOUNT%20-%20T%20CIFS%20DE%20ETC%20FSTAB.png" />      

   * **[FIREFOX]**
   
      * smb://mygroup

      * smb://smb.edt.org

   * **[NAUTILUS]**

      * Other Locations --> Connect to Server --> Introducir los datos de algún usuario SAMBA. 
    
     <img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/PERE-NAUTILUS-0.png" />    

     <img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/PERE-NAUTILUS.png" /> 

     <img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/UBUNTU.png" /> 

      
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

         <img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/SMBPASSWD.png" />    

         <img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/PDBEDIT.png" />  


   * SMBCONTROL

   * SMBCQUOTAS

   * SMBCACLS

   * SMBCLIENT4

   * SMBSPOOL



* Podemos acceder a **RECURSOS SAMBA** con herramientas GRÁFICAS como *FIREFOX o NAUTILUS*

* 

#### SMBCLIENT

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

-------------------------------------------------------------------------

#### SMBTREE

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

-------------------------------------------------------------------------

#### SMBGET

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

-------------------------------------------------------------------------

#### MOUNT.CIFS

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
-------------------------------------------------------------------------

#### FIREFOX


   * **[FIREFOX]**
   
      * smb://mygroup

      * smb://smb.edt.org

   * **[NAUTILUS]**

      * Other Locations --> Connect to Server --> Introducir los datos de algún usuario SAMBA. 

-------------------------------------------------------------------------

#### NAUTILUS


   * **[FIREFOX]**
   
      * smb://mygroup

      * smb://smb.edt.org

   * **[NAUTILUS]**

      * Other Locations --> Connect to Server --> Introducir los datos de algún usuario SAMBA. 


-------------------------------------------------------------------------

### Unix Server con SAMBA

#### Ejemplo de configuración Server Shares

* Actúa como un simple **HOST** que ofrece **SHARES** a la **RED**.

* Ofrece **RECURSOS DE DISCO**:

   * Documentation /usr/share/doc --> Sólo de **LECTURA**.

   * Manpages /usr/share/man --> Sólo de **LECTURA**

   * Public /var/lib/samba/public --> De **READ/WRITE** para todos

   * Privat /var/lib/samba/privat --> Que no se muestra en los listados. Es **BROWSEABLE = NO**.

* Observar el fichero, se divide en *3 bloques*:

   * **Global**: Descripción general del *Servidor SAMBA*

   * **Shares**: Para *homes* y *printer* (estándar)

   * **Shares** definidos por el **ADMINISTRADOR**

#### smb.conf
```
[global]
   workgroup = MYGROUP
   server string = Samba Server Version %v
   log file = /var/log/samba/log.%m
   max log size = 50
   security = user
   passdb backend = tdbsam
   load printers = yes
   cups options = raw
   
[homes]
   comment = Home Directories
   browseable = no
   writable = yes
;  valid users = %S
;  valid users = MYDOMAIN\%S

[printers]
   comment = All Printers
   path = /var/spool/samba
   browseable = no
   guest ok = no
   writable = no
   printable = yes

[documentation]
   comment = Documentació doc del container
   path = /usr/share/doc
   public = yes
   browseable = yes
   writable = no
   printable = no
   14guest ok = yes

[manpages]
   comment = Documentació man del container
   path = /usr/share/man
   public = yes
   browseable = yes
   writable = no
   printable = no
   guest ok = yes

[public]
   comment = Share de contingut public
   path = /var/lib/samba/public
   public = yes
   browseable = yes
   writable = yes
   printable = no
   guest ok = yes

[privat]
   comment = Share d'accés privat
   path = /var/lib/samba/privat
   public = no
   browseable = no
   writable = yes
   printable = no
   guest ok = yes
```


#### Instalación

1. Instalar los paquetes relacionados con SAMBA: *samba* *samba-client*

2. Encender los servicios **smbdc** y **nmbd**.

3. Modificar el fichero **smb.conf** a gusto del *USUARIO* con los parámetros adecuados.

4. Establecer **SHARES de DISCO** adecuados con sus **PARÁMETROS DE SEGURIDAD**

4. Crear **USUARIOS UNIX** y posteriormente **USUARIOS SAMBA existentes**.

5. Verificar integridad de los **USUARIOS** SAMBA con **PDBEDIT -L**.

4. Utilizamos *testparm* para verificar la configuración de */etc/samba/smb.conf*.

**Si tienes BIND9**

* Configurar BIND9 en todos los hosts y añadir el WORKGROUP para la resolución.

**Si tienes DOCKER**

* La resolución es *automática*.

* Hay que encender 3 DOCKERS: Ldap:group + PAM:ldap + SAMBA:base.

* Configurar el *pam_mount.conf.xml* para que monte automáticamente del tipo *CIFS*

5. Probar órdenes cliente como SMBPASSWD, SMBGET, SMBCLIENT, MOUNT.CIFS...

------------------------------------------------------------------------

### Name Resolution

* WINS --> Protocol de Nombres de Windows. Tipo DNS. Actua como Netbeui. Resuelve nombres Netbeui a IP.

```
name resolve order = ...
wins server = yes/adreçaIP
wins support = yes/no
```

* **WINS Server** --> **YES** --> Realiza la función de Server WINS.

* **WINS Support** --> **YES/IP** --> Hace que los hosts de RED sean clientes de WINS.

* Imita el fichero */etc/hosts* de Linux --> Windows usa Netbeui en */etc/samba/lmhosts*.

------------------------------------------------------------------------

#### Resolución Hosts Clientes de Windows

##### Utilización de Imhosts


* lmhosts --> Resuelve nombres de Netbeui.

* No tenemos **clientes Windows**, pero esta utilidad nos resuelve **CLIENTES WINDOWS**.

*Ejemplo*

```
root@939c09590bdc /]# nmblookup -S 3145DBF85061 ​ (és el Master Browser)
172.17.0.8 3145DBF85061<00>
Looking up status of 172.17.0.8
3145DBF85061
<00> -
B <ACTIVE>
3145DBF85061
<03> -
B <ACTIVE>
3145DBF85061
<20> -
B <ACTIVE>
..__MSBROWSE__. <01> - <GROUP> B <ACTIVE>
MYGROUP
<00> - <GROUP> B <ACTIVE>
MYGROUP
<1d> -
B <ACTIVE>
MYGROUP
<1e> - <GROUP> B <ACTIVE>
MAC Address = 00-00-00-00-00-00
```

------------------------------------------------------------------------

##### Utilización Wins

```
# This section details the support for the Windows Internet Name Service (WINS).
# Note: Samba can be either a WINS server or a WINS client, but not both.
# ​ wins support​​ = when set to yes, the NMBD component of Samba enables its WINS
# server.
#
# ​ wins server ​ = tells the NMBD component of Samba to be a WINS client.
# ​ wins proxy​​ = when set to yes, Samba answers name resolution queries on behalf
# of a non WINS capable client. For this to work, there must be at least one
# WINS server on the network. The default is no.
# ​ dns proxy​​ = when set to yes, Samba attempts to resolve NetBIOS names via DNS
# nslookups.
```

------------------------------------------------------------------------


#### Resolución Hosts Clientes de GNU/Linux 

* Desde /etc/hosts

* Desde BIND9

* Docker es automático.

#### El servicio nmbd

* Windows usa el SERVICIO **/usr/sbin/nmbd** para la resolución de *NOMBRES HOSTS WINDOWS*.

------------------------------------------------------------------------

### Master Browser

* En una red Windows entre hosts donde no hay un **Controlador de DOMINIO (PDC)**, los equipos compiten para escoger un *local master browser* --> Se llama *ELECCIONES*

* Toda subred, escoge su MASTER BROWSER.

* Están bajo un PDC (Controlador Dominio Principal) --> Domain Master Browser

```
local master = no/yes
os level = nº
preferred master = no/yes
```

* Directivas:

   * local master: --> 
   
      * No --> Significa que nunca será LOCAL MASTER BROWSER. 
      
      * Yes --> Dice que sí se postula, pero tiene que ganar las *ELECCIONES*.

   * os level: --> Indica un valor, depende del SO.

   * preferred master: --> *Forza* elecciones.

------------------------------------------------------------------------

#### Primer Caso 

* 2 hosts de SAMBA, no juegan ningún rol de PDC, uno de ellos hace de LOCAL MASTER BROWSER.

[falta_revisar_mañana] [PEGAR_FOTO]

------------------------------------------------------------------------

#### Segundo Caso

* El WorkGroup --> NEWGROUP --> 1 de ellos fuerza modificaciones para que sea master browser.

[falta_revisar_mañana] [PEGAR_FOTO]

------------------------------------------------------------------------

#### Tercer Caso

* 4 containers de Docker como Samba Server (No PDC), se modifica el *os_level* y el *preferred_master* para hacerlo *master browser*

------------------------------------------------------------------------

### Domain Master Browser

* 2 hay tipos:

   * **Local Master Browsing**: Cada subred, se escoge via *ELECCIONES*.

   * **Domain Master Browsing**: Múltiples subredes diferentes en un Dominio de Windows, gestionado por un *Controlador de Dominio Principal (PDC)*. 
   Hace de Domain Master Browsing y Local Master Browsing. No se escoge por elección, sino el *ADMIN configura* las opciones.

   ```
   domain master = yes/no
   preferred master = yes/no
   local master = yes/no
   os level = nº
   ```

------------------------------------------------------------------------

## Users / Groups (Share Options) Security

### Users / Groups

* A los **SHARES** se pueden establecer **REQUISITOS** según el **USUARIO**.

* SAMBA usa una **base de datos** *propia* (*tdbsam*) de USUARIOS.

* Estos usuarios tienen que existir en UNIX Localmente para poderse añadir a SAMBA.

* Las órdenes **SMBPASSWD** y **PDBEDIT** hace la función.

[IMPORTANTE]

**LISTADO DE OPCIONES DE CONFIGURACIÓN DE SHARES**

#### smb.conf
```
path = /dir1/dir2/share
comment = share description
volume = share name
browseable = yes/no
max connections = #

public = yes/no
guest ok = yes/no
guest account = unix-useraccount
guest only = yes/no

valid users = user1 user2 @group1 @group2 …
invalid users = user1 user2 @group1 @group2 …
auto services = user1 user2 @group1 @group2 …
admin users = user1 user2 @group1 @group2 …

writable = yes/no
read only = yes/no
write list = user1 user2 @group1 @group2 …
read list = user1 user2 @group1 @group2 …

create mode = 0660
directory mode = 0770

```

*EJEMPLO 1*

```
[dave]
path = /home/dave
comment = Dave's home directory
writable = yes
valid users = dave
```

* Se crea un **SHARE** la **HOME** de DAVE.

* Es **WRITABLE**.

* Pero **SÓLO** puede **ACCEDER** DAVE (**VALID USERS**).

=========================

**KESHI**

[compartida]
	comment = Compartida
	path = /tmp/compartida
	browseable = Yes
	writable = Yes
	valid users = pere

* Se crea un **SHARE** de /tmp/compartida.

* Es **WRITABLE** y **BROWSEABLE**.

* Pero sólo puede **ACCEDER PERE**.

======================

#### smb.conf
```
[accounting]
25comment = Accounting Department Directory
writable = yes
valid users = @account
path = /home/samba/accounting
create mode = 0660
directory mode = 0770
```

* El **directorio** tendrá una *máscara* 770.

* Podrá acceder el grupo @account.

```
# mkdir /home/samba/accounting
# chgrp account /home/samba/accounting
# chmod 770 /home/samba/accounting
```

#### smb.conf
```
[global]
invalid users = root bin daemon adm sync shutdown halt mail news uucp operator
auto services = dave peter bob


[homes]
browsable = no
writable = yes


[sales]
path = /home/sales
comment = Sedona Real Estate Sales Data
writable = yes
valid users = sofie shelby adilia
admin users = mike


[salesbis]
path = /home/sales
comment = Sedona Real Estate Sales Data
read only = yes
write list = sofie shelby
```

[IMPORTANTE]

------------------------------------------------------------------------

## SHARE LEVEL ACCESS OPTIONS

* admin users --> Users who can perfom operations as **root**

* valid users --> Users who **can connect** to a **share**

* invalid users --> Users who will be **denied access** to a **share**

* read list --> Users who have **read-only** access to a **writable share**

* write list --> Users who have **read/write** access to a **read-only share**

* max connections --> Max numbers of connections at the same time

* guest only --> If yes, Only guest access.

* guest account --> Unix account --> guest access

------------------------------------------------------------------------

#### SMBPASSWD 

* Para crear **USUARIOS SAMBA**, se basan en usuarios **UNIX LOCAL**, tienen que existir.

*EJEMPLO HOW TO*

El següent exemple mostra com crear quatre usuaris super3!. Tot seguit mostra diferents formes d’accés al recurs documentation:

● connecta amb l’usuari unix utilitzat en el client.

● connecta com a usuari anìnim: guest

● connecta com a usuària lila i demana el password interactivament

● connecta com a usuària lila amb el password indicat en la línia de comandes.

```
server# smbpasswd -a lila
server# smbpasswd -a patipla
server# smbpasswd -a rock
server# smbpasswd -a pla

client$ smbclient //host01/documentation
client$ smbclient -N //host01/documentation
client$ smbclient //host01/documentation -U lila
client$ smbclient //host01/lila -U lila%smblila
```

```
Amb ​ pdbedit ​ podem llistar els usuaris samba:
[root@samba docker]# pdbedit -L
patipla:1000:
roc:1002:
lila:1001:
pla:1003:
```

* Para ver todos los datos de las cuentas.

   [importante]

   * **pdbedit -vL**

   ------------------------------------------------------------------------

#### Ejemplos de validación de Usuarios

* Con la orden **testparm**, podemos ver o observar que directivas de configuración de los SHARES están definidas.

#### smb.conf
```
[global]
workgroup = MYGROUP
server string = Samba Server Version %v
log file = /var/log/samba/log.%m
max log size = 50
security = user
passdb backend = tdbsam
load printers = yes
cups options = raw
```

##### Ejemplo 1: USUARIO GUEST ACCEDE A //SAMBA/PUBLIC

* **guest ok = yes**

* Permet l’accés al **share de usuaris anònims**, sense identificar. és equivalent a la opció *public = yes*.


Observar que l’accés a disc de l’usuari anònim guest es transforma (id mapping) en l’usuari unix ​ **nobody** ​ .

#### smb.conf
```
[public]
comment = Share de contingut public
path = /var/lib/samba/public
browseable = yes
writable = yes
guest ok = yes
```

##### Ejemplo 2: SÓLO GUEST

* **guest only = yes**

* Permite **ÚNICAMENTE** acceder al recurso via **ANÓNIMO**.

* No permite acceso via **USUARIO**.

* En verdad sí nos deja acceder pero, en realidad somos *nobody*.

#### smb.conf
```
[public]
   comment = Share de contingut public
   path = /var/lib/samba/public
   browseable = yes
   writable = yes
   printable = no
   guest only = yes
```

```
[ecanet@d02 samba:18users]$ smbclient -U lila //samba/public
Enter SAMBA\lila's password:
Try "help" to get a list of possible commands.
smb: \> get README.md
getting file \README.md of size 1900 as README.md (1855.3 KiloBytes/sec) (average
1855.5 KiloBytes/sec)
smb: \> put README.md red3.txt
putting file README.md as \red3.txt (927.7 kb/s) (average 927.7 kb/s)
smb: \>
[root@samba docker]# ll /var/lib/samba/public/
-rw-r--r--. 1 root root 375 Dec 14 11:27 Dockerfile
-rw-r--r--. 1 root root 1900 Dec 14 11:27 README.md
-rwxr--r--. 1 nobody nobody 1900 Dec 14 11:43 red3.txt
```

*-rwxr--r--. 1 nobody nobody 1900 Dec 14 11:43 red3.txt*

------------------------------------------------------------------------

##### Ejemplo 3: SÓLO USUARIO GUEST CON IDMAP A UNA CUENTA UNIX

* Está deprecated guest account. Pero permet accés a un *usuari guest existent del sistema*.

* *guest ok = yes*
* *guest account = pla*


#### smb.conf
```
[public]
comment = Share de contingut public
30path = /var/lib/samba/public
browseable = yes
writable = yes
guest ok = yes
guest account = pla

[ecanet@d02 samba:18users]$ smbclient -N //samba/public
Anonymous login successful
Try "help" to get a list of possible commands.
smb: \> get README.md
getting file \README.md of size 1900 as README.md (1855.3 KiloBytes/sec) (average
1855.5 KiloBytes/sec)
smb: \> put README.md red4.txt
putting file
```

------------------------------------------------------------------------

##### Ejemplo 4: USUARIO IDENTIFICADO

* Las ordenes cliente SAMBA, permiten indicar el nombre de **QUIÉN** usuario quiere **REALIZAR** la conexión.

   * $ **smbclient -U [user] //server/recurso**

   * $ **smbclient -U [user%password] //server/recurso** 

```
[ecanet@d02 samba:18users]$ smbclient​ -U lila​ //samba/public
Enter SAMBA\lila's password:
Try "help" to get a list of possible commands.

smb: \> get README.md
getting file \README.md of size 1900 as README.md (927.7 KiloBytes/sec) (average 927.7
KiloBytes/sec)

smb: \> put README.md red5.txt
putting file README.md as \red5.txt (927.7 kb/s) (average 927.7 kb/s)

smb: \>
[root@samba docker]# ll /var/lib/samba/public/
-rw-r--r--. 1 root root 375 Dec 14 11:27 Dockerfile
-rw-r--r--. 1 root root 1900 Dec 14 11:27 README.md
-rwxr--r--. 1 lila lila 1900 Dec 14 11:49 red5.txt
```

------------------------------------------------------------------------

##### Ejemplo 5: VALID USERS

* Permite indicar una **LISTA DE USUARIOS VÁLIDOS** para acceder al **RECURSO**.

* Otros usuarios **no** podrán acceder. 

* Tampoco **guest** aunque esté indicado **guest ok**

**valid users = [user1] [user2] [userN]**

#### smb.conf
```
[public]
   comment = Share de contingut public
   path = /var/lib/samba/public
   browseable = yes
   writable = yes
   guest ok = yes
   valid users = patipla roc
```

```
[ecanet@d02 samba:18users]$ smbclient ​ -N​ //samba/public
Anonymous login successful
tree connect failed: NT_STATUS_ACCESS_DENIED

[ecanet@d02 samba:18users]$ smbclient ​ -U lila​ //samba/public
Enter SAMBA\lila's password:
tree connect failed: NT_STATUS_ACCESS_DENIED

[ecanet@d02 samba:18users]$ smbclient ​ -U patipla​ //samba/public
Enter SAMBA\patipla's password:
Try "help" to get a list of possible commands.
smb: \>

[root@hostedt tmp]# smbclient ​ -U roc%roc​ //samba/public
Domain=[MYGROUP] OS=[Windows 6.1] Server=[Samba 4.7.10]
```

------------------------------------------------------------------------

##### Ejemplo 6: INVALID USERS

* Indica una **LISTA DE USUARIOS PARA DENEGAR** el acceso al **RECURSO**.

* El resto de usuarios válidos **sí** podrán acceder.

* **Guest** dependerá si tiene permitido o no via guest ok.

**invalid users = [user1] [user2] [userN]**

#### smb.conf
```
[public]
   comment = Share de contingut public
   path = /var/lib/samba/public
   browseable = yes
   writable = yes
   guest ok = yes
   invalid users = patipla roc
```

```
[ecanet@d02 samba:18users]$ smbclient ​ -N​ //samba/public
Anonymous login successful
Try "help" to get a list of possible commands.

smb: \>
[ecanet@d02 samba:18users]$ smbclient ​ -U lila​ //samba/public
Enter SAMBA\lila's password:
Try "help" to get a list of possible commands.

smb: \>
[ecanet@d02 samba:18users]$ smbclient​ - ​ U patipla ​ //samba/public
Enter SAMBA\patipla's password:
tree connect failed: NT_STATUS_ACCESS_DENIED
```
------------------------------------------------------------------------

##### Ejemplo 7: ADMIN USERS

* Permite definir un conjunto de usuarios **SAMBA** que serán convertidos [id_mapping] al usuario ROOT.

* Es decir que los **usuarios SAMBA** entrarán al **RECURSO** como si fueran **ADMINISTRADORES**.

```
[root@hostedt tmp]# smbclient ​ -U roc%roc​ //samba/public
Domain=[MYGROUP] OS=[Windows 6.1] Server=[Samba 4.7.10]

smb: \> get README.md
getting file \README.md of size 1900 as README.md (927,7 KiloBytes/sec) (average 927,7
KiloBytes/sec)

smb: \> put README.md file1.pdf
putting file README.md as \file1.pdf (1855,3 kb/s) (average 1855,5 kb/s)

smb: \>
[root@samba docker]# ll /var/lib/samba/public/
-rw-r--r--. 1 root root 1900 Dec 14 15:44 README.md
-rwxr--r--. 1 ​ root​​ roc 1900 Dec 14 15:52 file1.pdf
```

------------------------------------------------------------------------

#### Ejemplo de lectura / escritura / mode

* Los recursos se pueden configurar sólo de **lectura** o de **lectura/escritura**.

* Se puede indicar una lista explícita de **quién puede leer** y de **quién puede escribir**.

* También permite añadir **máscaras** a los ficheros. Con el **MODE**

------------------------------------------------------------------------

##### Ejemplo 8: RECURSO SÓLO DE LECTURA

* **read only = yes** **[read_only=yes]**

* **writable = no** **[writable=no]**

Sólo de *LECTURA*.

------------------------------------------------------------------------

##### Ejemplo 9: RECURSO DE LECTURA / ESCRITURA

* **read only = no** **[read_only=no]**

* **writable = yes** **[writable=yes]**

Sólo de **WRITABLE** tiene los **2 PERMISOS, lectura y escritura**.


------------------------------------------------------------------------

##### Ejemplo 10: LISTA DE USUARIOS AUTORIZADOS

* **read List = user1 user2 usern** **[read_list=user1_user2_userN]**

* **writable = yes** **[writable=yes]**

Lista de usuarios que sólo pueden **LEER**.

   Sirve para **restringir USUARIOS** dónde **SÓLO** puedan **LEER**.

   El resto puede escribir con **writable = yes**.
   
   Sólo de **WRITABLE** tiene los **2 PERMISOS, lectura y escritura**.

#### smb.conf
```
[public]
   comment = Share de contingut public
   path = /var/lib/samba/public
   writable = yes
   guest ok = yes
   read list = pla
```

```
[root@hostedt tmp]# smbclient ​ -U roc%roc​ //samba/public
Domain=[MYGROUP] OS=[Windows 6.1] Server=[Samba 4.7.10]

smb: \> ls
.        D      0 Fri Dec 14 17:31:06 2018
..       D      0 Fri Dec 14 16:45:31 2018
file3.txt       A 1900 Fri Dec 14 17:31:06 2018

10474496 blocks of size 1024. 9892316 blocks available

smb: \> rm file3.txt

smb: \>

[root@hostedt tmp]# smbclient ​ -U lila​ //samba/public
Enter lila's password:
Domain=[MYGROUP] OS=[Windows 6.1] Server=[Samba 4.7.10]


smb: \> put README.md file1.txt
putting file README.md as \file1.txt (927,7 kb/s) (average 927,7 kb/s)

smb: \>
[root@hostedt tmp]# smbclient ​ -U pla​ //samba/public
Enter pla's password:
Domain=[MYGROUP] OS=[Windows 6.1] Server=[Samba 4.7.10]

smb: \> ls
.
D
0 Fri Dec 14 17:44:09 2018
..
D
0 Fri Dec 14 16:45:31 2018
file3.txt
A
1900 Fri Dec 14 17:44:09 2018
10474496 blocks of size 1024. 9892312 blocks available

```
* Da **ERROR**

```

smb: \> rm file3.txt
NT_STATUS_MEDIA_WRITE_PROTECTED deleting remote file \file3.txt
NT_STATUS_MEDIA_WRITE_PROTECTED listing \file3.txt


smb: \>


smb: \> put README.md file4.txt
NT_STATUS_ACCESS_DENIED opening remote file \file4.txt
smb: \>
```

------------------------------------------------------------------------

##### Ejemplo 11: LISTA DE USUARIOS AUTORIZADOS PARA ESCRITURA

* **write list = user1 user2 usern** **[write_list=user1_user2_userN]**

* **writable = no** **[writable=no]**

Lista de usuarios que sólo pueden **ESCRIBIR**.

   Sirve para **FILTRAR USUARIOS** dónde **SÓLO** puedan **ESCRIBIR**.

   El resto **SÓLO PUEDE LEER** con **writable = no**.
   
   Sólo de **WRITABLE / WRITE LIST** tiene los **2 PERMISOS, lectura y escritura**.


#### smb.conf
```
[public]
   comment = Share de contingut public
   path = /var/lib/samba/public
   writable = no
   guest ok = yes
   write list = pla
```

```
[root@hostedt tmp]# smbclient​ -U lila%lila​ //samba/public
Domain=[MYGROUP] OS=[Windows 6.1] Server=[Samba 4.7.10]

smb: \> rm file1.pdf
NT_STATUS_MEDIA_WRITE_PROTECTED deleting remote file \file1.pdf
35NT_STATUS_MEDIA_WRITE_PROTECTED listing \file1.pdf
smb: \>

[root@hostedt tmp]# smbclient​ -U pla​ //samba/public
Enter pla's password:
Domain=[MYGROUP] OS=[Windows 6.1] Server=[Samba 4.7.10]

smb: \> rm file1.pdf

smb: \> put README.md file1.pdf
putting file README.md as \file1.pdf (1855,3 kb/s) (average 1855,5 kb/s)

smb: \>
```

------------------------------------------------------------------------

##### Ejemplo 12: MODO DE DIRECTORIO Y FICHERO

* **create mode = [mode]** **[create_mode=0660]**

* **directory mode = [mode]** **[directory_mode=0660]**

* Permiten establecer **MÁSCARAS a DIRECTORIOS** y **FICHEROS** en una nueva **CREACIÓN** dentro del **SHARE**

```
[root@samba docker]# ll /var/lib/samba/public/
-rwxr--r--. 1 pla
pla
1900 Dec 14 16:53 file1.pdf
-rwxr--r--. 1 lila lila 1900 Dec 14 16:42 file1.txt
-rwxr--r--. 1 nobody nobody 1900 Dec 14 16:28 file2.txt
-rwxr--r--. 1 nobody nobody 1900 Dec 14 16:44 file3.txt
```

#### smb.conf
```
[public]
   comment = Share de contingut public
   path = /var/lib/samba/public
   writable = yes
   guest ok = yes
   create mode = 0660
   directory mode = 0770
```

------------------------------------------------------------------------

### Security

[FALTA]

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