# SAMBA
# KESHIKID03 / AARON ANDAL
## @edt ASIX M06 2021-2022

Podeu trobar les imatges docker al Dockehub de [edtasixm06](https://hub.docker.com/u/edtasixm06/)

Podeu trobar la documentació del mòdul a [ASIX-M06](https://sites.google.com/site/asixm06edt/)


ASIX M06-ASO Escola del treball de barcelona

### Imatges:

* **keshikid03/samba21:base** Servidor SAMBA bàsic amb *shares* d'exemple.

* **keshikid03/samba21:base_vFinal** 

	* Servidor SAMBA bàsic amb *shares* d'exemple. Versión Final. 17.01.22

 	* Servidor SAMBA amb usuaris locals i usuaris LDAP (Unix).
 	
 	* Es creen comptes d'usuari samba de usuaris locals i de alguns dels usuaris ldap (no tots).
 	
 	* Es creen també els directoris home dels usuaris de ldap i se'ls assigna la pripietat/grup pertinent.
 	
 	* Finalment s'exporten els shares d'exemple usuals i els [homes] dels usuaris samba.
 	
 	* D'aquesta manera un hostpam (amb ldap) pot muntar els homes dels usuaris (home dins home) usant samba.

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

## INDEX
**AWS EDUCATE - PAM SAMBA LDAP**: [readme AWS DOCKER PAM SAMBA LDAP](https://github.com/KeshiKiD03/samba21#pr%C3%A1ctica-pam---ldap---samba-en-aws-educate)

**SAMBA HELP KESHI**: [readme SAMBA](https://github.com/KeshiKiD03/samba21#samba-help-keshi)
* **18.01.2022 - HOW TO SAMBA [IMPORTANTE] AARON ANDAL**: [readme](https://github.com/KeshiKiD03/samba21#18012022---how-to-samba-importante-aaron-andal)
* **UNIX CLIENTES CON SAMBA**: [readme](https://github.com/KeshiKiD03/samba21#unix-clients-con-samba)
* **SMBCLIENT**: [readme](https://github.com/KeshiKiD03/samba21#smbclient)
* **SMBTREE**: [readme](https://github.com/KeshiKiD03/samba21#smbtree)
* **SMBGET**: [readme](https://github.com/KeshiKiD03/samba21#smbget)
* **MOUNT.CIFS**: [readme](https://github.com/KeshiKiD03/samba21#mountcifs)
* **USERS GROUPS / SECURITY OPTIONS**: [readme](https://github.com/KeshiKiD03/samba21#users--groups-share-options-security)
* **SHARE LEVEL SECURITY OPTIONS**: [readme](https://github.com/KeshiKiD03/samba21#share-level-access-options)
* **EJEMPLOS DE VALIDACIÓN DE USUARIOS**: [readme](https://github.com/KeshiKiD03/samba21#ejemplos-de-validaci%C3%B3n-de-usuarios)
* **ROLES SAMBA**: [readme](https://github.com/KeshiKiD03/samba21#roles-del-servidor-samba)
* **REPASO ÓRDENES CLIENTE**: [readme](https://github.com/KeshiKiD03/samba21#repaso-de-%C3%B3rdenes-cliente)
* **ARQUITECTURA Y EJEMPLOS CON PAM Y LDAP**: [readme](https://github.com/KeshiKiD03/samba21#arquitectura)
* **PRÁCTICA SAMBA + PAM + LDAP (EN LOCAL)**: [readme](https://github.com/KeshiKiD03/samba21#pr%C3%A1ctica-samba--ldap--pam)

## -------------------------

## NECESARI (ARQUITECTURA) (LDAP + PAM + SAMBA):

  * **2hisx** Una xarxa propia per als containers implicats.

   * **ldap21:group** 
   
   	* Un servidor ldap en funcionament amb els usuaris de xarxa.
   	
   	* Incorpora els posixGroup dels usuaris (per memberUid).

   * **samba21:base_vFinal** Un servidor samba que exporta els homes dels usuaris com a shares via [homes] Caldrà fer les tasques següents en el servidor samba:

      ○ **Usuaris unix** Samba requereix la *existència* de usuaris unix. Per tant caldrà disposar dels *usuaris unix*, poden ser locals o de xarxa via LDAP. 
      
      Així doncs, el *servidor samba* ha d'estar *configurat* amb *nscd i nslcd* per *poder accedir al ldap*.

      Amb *getent* s'han de poder llistar tots els usuaris i grups de xarxa.

      ○ **homes** Cal que els usuaris tinguin un directori home. Els usuaris unix local ja en tenen en crear-se l'usuari, però els *usuaris LDAP* no. 
      
      Per tant cal crear el directori *home dels usuaris ldap* i assignar-li la propietat i el grup de l'usuari
      apropiat.

      ○ **Usuaris samba** 
      
  
  	    * Cal **crear els comptes d'usuari samba** (recolsats en l'existència del mateix usuari **unix**). 
  	    
  	    * Per a **cada usuari samba** els pot crear amb **smbpasswd** el compte d'usuasi samba assignant-li el password de samba. 
  	    
  	    * Convé que sigui el mateix que el de **ldap** per tal de que en fer login amb un sol password es validi l'usuari (auth de **pam_ldap.so**) i es munti el home via samba (**pam_mount.so**). 
  	    
  	    * Samba pot desar els seus usuaris en una base de dades local anomenada **tdbsam** o els pot desar en un servidor ldap usant com a backend **ldapsam**. 
  	    
  	    * El mecanisme més simple és usar **tdbsam** i **smbpasswd** i **pdbedit** com a utilitats.


   * **pam21:ldap** Un hostpam configurat per accedir als usuaris **locals** i **ldap** i que usant **pam_mount.so** munta dins del home dels usuaris un home de xarxa via samba. 
   
      * Cal configurar **/etc/security/pam_mount.conf.xml** per muntar el recurs samba dels [homes].
      
      * Host pam amb authenticació ldap.
      
      * Utilitza l'ordre authconfig per configurar l'autenticació i a més a més crea els home dels usuaris i munta un tmpfs als usuaris. Atenció, per poder realitzar el mount cal que el container es generi amb l'opció --privileged.

 

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

==========================================================================================

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
smbclient -N -L
```

6. Listado con USUARIO LDAP: smbclient -U pere -L [ip_samba]

```
smbclient -U pere%pere -L

% --> Permite añadir la contraseña por input

```

---

### Pruebas de ACCESO

7. Accedemos al recurso DOC con el usuario PERE --> smbclient -U pere //[ip_samba]/doc

```

smbclient -U pere%pere //smb.edt.org/doc

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

* MÁS ADELANTE LO VEMOS CON DETALLE.

---

### MOUNT

* mount -t cifs -o <user> //<IP>/<path_origen> <destí>

* MÁS ADELANTE LO VEMOS CON DETALLE.

---

### Nautilus

* smb://<IP>

* MÁS ADELANTE LO VEMOS CON DETALLE.


==========================================================================================

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

Niveles de seguridad y autenticación.

   * **SHARE-LEVEL SECURITY**

   * **USER-LEVEL SECURITY**

   * **SERVER-LEVEL SECURITY**

   * **DOMAIN-LEVEL SECURITY**

```
[global]
security = share

[data]
username = andy, peter, terry

```

```
[global]
security = user
[accounting1]
writable = yes
valid users = bob, joe, sandy
```

```
[global]
security = server
password server = mixtec toltec
```

* Los ejercicios planteados son con equipos **standalone** --> Tipo **USER**.

* La *base de datos* de usuarios y seguridad es el **tbdsam**.

```
[global]
   workgroup = MYGROUP
   server string = Samba Server Version %v
   log file = /var/log/samba/log.%m
   max log size = 50
   security = user
   passdb backend = tdbsam
   load printers = yes
```

------------------------------------------------------------------------

#### Repaso al modelo de trabajo

* **[CLIENTE_UNIX]**

   * El usuario PERE --> Se conecta a un share y descarga.

      Todo lo que se descargue estará a su **nombre**.

* **[USUARIO_SAMBA]**

   * Con un smbclient -U [user] //server/recurso ...

      * Estamos indicando que se conectará al servidor como [user]

      * Tiene que ser **USUARIO SAMBA VÁLIDO**

      * Tienen que tener **PASSWORD SAMBA** asignado --> Usa **tbdsam**.

* **[USUARIO_UNIX_DESTINO]**

   * Cuando *pere* hace acciones en el SISTEMA DE FICHEROS ...

      * Lo hace en nombre de *patipla* .

         * Se tienen que traducir para que se pueda hacer **"mapping"** a un usuario **UNIX VÁLIDO**

* **[EJEMPLOS DE SEGURIDAD]**

* El *acceso remoto* al servicio se aplican *reglas del servicio*.

* Una vez superadas los *permisos* de *SAMBA*, 

   * Hace falta pasar los *permisos* del *sistema de ficheros* DE UNIX.

ES DECIR POR MUCHO QUE SAMBA NOS DEJE, SI EL DIRECTORIO NO PERMITE ESCRITURA. LA USUARIA PATIPLA NO PODRÁ BORRAR NI SUBIR NADA.

PREVALECEN LOS PERMISOS DE UNIX.

------------------------------------------------------------------------

### Directorio Home de los usuarios

* Un usuario puede acceder a su home vía recurso/share de SAMBA.

*EJEMPLO DE SHARE DE HOME*

```
[myhome]
   comment = Share amb els homes dels usuaris
   path = /home/%U
   writable = yes
   guest ok = no
   browseable = no
```

## EJEMPLO ERRONEO / ¡Una mala forma de trabajar!

```
[root@hostedt tmp]# smbclient -U roc%roc //samba/myhome
Domain=[MYGROUP] OS=[Windows 6.1] Server=[Samba 4.7.10]
smb: \> ls
. D 0 Fri Dec 14 16:44:38 2018
.. D 0 Fri Dec 14 16:44:41 2018
.bash_logout H 18 Mon Jun 18 10:37:45 2018
.bash_profile H 193 Mon Jun 18 10:37:45 2018
.bashrc H 231 Mon Jun 18 10:37:45 2018
10474496 blocks of size 1024. 9892316 blocks available
smb: \> pwd
Current directory is \\samba\myhome\
smb: \> mkdir soc-en-roc

```

```
[root@hostedt ~]# smbclient -U lila%lila //samba/myhome
Domain=[MYGROUP] OS=[Windows 6.1] Server=[Samba 4.7.10]
smb: \> ls
. D 0 Fri Dec 14 16:44:37 2018
.. D 0 Fri Dec 14 16:44:41 2018
.bash_logout H 18 Mon Jun 18 10:37:45 2018
.bash_profile H 193 Mon Jun 18 10:37:45 2018
.bashrc H 231 Mon Jun 18 10:37:45 2018
10474496 blocks of size 1024. 9892332 blocks available
smb: \>
```

* Observamos el ejemplo anterior que *"roc"* se conecta al recurso *"myhome"*.

   * En otra sesión, la usuaria *"lila"* cuando accede al mismo recurso, en realidad no entra al de *"roc"* sino a su home *"lila"*


## EJEMPLO CORRECTO / Exportar los Homes de los usuarios (una buena forma de trabajar)

* **SAMBA** **AUTOMATIZA** la exportación de los **DIRECTORIOS HOME** de los usuarios en un **SHARE** que viene por **DEFECTO**.

   * Este recurso se llama **[homes]**

      * Por **DEFECTO** está activado.

      * No está **BROWSEABLE**.

      * Es de **lectura/escritura** = **WRITABLE**

```
[homes]
      comment = Home Directories
      browseable = no
      writable = yes
      ; valid users = %S
      ; valid users = MYDOMAIN\%S
```

* El acceso a la **home** de los usuarios SAMBA es simple.

   * **SE ACCEDE VÍA NOMBRE DE USUARIO EN LUGAR DEL SHARE**

      * SMBCLIENT -U roc%roc [//samba/roc]

```
[root@hostedt ~]# smbclient -U patipla%patipla //samba/patipla
Domain=[MYGROUP] OS=[Windows 6.1] Server=[Samba 4.7.10]
smb: \> pwd
Current directory is \\samba\patipla\
smb: \> ls
. D 0 Fri Dec 14 16:44:36 2018
.. D 0 Fri Dec 14 16:44:41 2018
.bash_logout H 18 Mon Jun 18 10:37:45 2018
.bash_profile H 193 Mon Jun 18 10:37:45 2018
.bashrc H 231 Mon Jun 18 10:37:45 2018
10474496 blocks of size 1024. 9892352 blocks available
smb: \>
```


------------------------------------------------------------------------

## Global Options

------------------------------------------------------------------------

### General

```
global]
...
[homes]
...
[printers]
...
[test]
...

```

* Se pueden definir opciones generales por *DEFECTO*
```
[global]
      netbios name = toltec
      server string = Samba %v on %L
      workgroup = METRAN
      encrypt passwords = yes
      wins support = yes
      read only = no
```

* **ALGUNAS VARIABLES PARA GLOBAL**

[%a] Client's architecture (see Table 6-1)<br/>

[%I] Client's **IP address** (e.g., 172.16.1.2)<br/>

[%m] Client's **NetBIOS name**<br/>

[%M] Client's *DNS name*<br/>

[%u] Current **Unix** username<br/>

[%U] Requested **client username** (not always used by Samba)<br/>

[%H] **Home directory of %u**<br/>

[%g] Primary group of %u<br/>

[%G] Primary group of %U<br/>

[%S] **Current share's name**<br/>

[%P] Current share's root directory<br/>

[%p] Automounter's path to the share's root directory, if different from [%P]<br/>

[%d] Current server process ID<br/>

[%h] Samba **server's DNS hostname**<br/>

[%L] Samba **server's NetBIOS name**<br/>

[%N] Home directory server, from the automount map<br/>

[%v] Samba **version**<br/>

[%R] The SMB protocol level that was negotiated<br/>

[%T] The current date and time<br/>

[%$var] The value of environment variable var<br/>


------------------------------------------------------------------------

### Hosts Allow/Deny

1. SI NO HAY **allow or deny options** en *smb.conf*.

   * **SAMBA** **permite conexiones** de cualquier sistema.

2. SI HAY hosts para **PERMITIR O DENY** en **[global]** es a nivel **GLOBAL**. Incluso si se permiten en los **SHARES**

3. Si hay **"[HOST_ALLOW]"** en un **SHARE**, sÓlo los **HOSTS LISTADOS** estarán **[PERMITIDOS]** entrar al **SHARE**.

4. 3. Si hay **"[HOST_DENY]"** en un **SHARE**, solo los **HOSTS LISTADOS** estarán **[DENEGADOS]** entrar al **SHARE**, OTROS HOSTS **PODRÁN** ENTRAR.

5. Si están LAS **[2_OPCIONES]**, **ALLOW** tiene **PRECEDENCIA**.

*EJEMPLO DE PRECEDENCIA*

* **host allow** = 111.222.

* **host deny** = 111.222.333.

* La subnet 111.222.*.* podrá permitir acceder a SAMBA SHARES.

* La lista del **DENY**, no valdrá porque hay un **ALLOW** permitiendolo

* Para ello se emplea el **EXCEPT**.

   * **host allow = 111.222. EXCEPT 111.222.333.**


```
[global]
   # Networking configuration options
   hosts allow = 192.168.220. 134.213.233.
   hosts deny = 192.168.220.102
   interfaces = 192.168.220.100/255.255.255.0 \
   134.213.233.110/255.255.255.0
   bind interfaces only = yes

```

1. Si no hay **ALLOW o DENY** --> Samba permitirá.

2. Si hay **ALLOW O DENY** en [global] --> Esto aplica a todos los **SHARES**.

3. Si sólo hay **HOSTS ALLOW** en **SHARE**, sólo los **HOSTS** de la **LISTA** podrán **ENTRAR**.

4. 3. Si sólo hay **HOSTS DENY** en **SHARE**, cualquier **HOST PODRÁ ENTRAR** al **SHARE** excepto los **DENY**

5. **SI ESTÁN LAS 2 OPCIONES, PREVALECE HOST ALLOW.**

* host allow = 

   * HOSTNAME = ftp.example.com

   * IP

   * Domain names

   * Netgroups @

   * Subnets --> 130.64.6.

   * ALL --> PARA TODO

   * EXCEPTO --> Excepciones 
------------------------------------------------------------------------

### Logging

------------------------------------------------------------------------

## Roles del servidor SAMBA

------------------------------------------------------------------------

### Roles

* Roles SAMBA:

   * Servidor Standalone.

   * PDC controlador Principal de Dominio

   * Member Server

   * Browser.

   * Name Resolution.

### STANDALONE SERVER OPTIONS

* **[security]** = user / share (deprecated)

* [**passdb_backend**] = tdbsam --> Es la BD.

```
# ----------------------- Standalone Server Options ------------------------
# security = the mode Samba runs in. This can be set to user, share (deprecated), or server
(deprecated).
# passdb backend = the backend used to store user information in. New installations should
use either tdbsam or ldapsam. No additional configuration is required for tdbsam. The
"smbpasswd" utility is available for backwards compatibility.
security = user
passdb backend = tdbsam

```

### DOMAIN CONTROLLER OPTIONS (PDC)

* **[security]** = user

* **[passdb_backend]** = tdbsam

* **[domain_master]** = yes --> Especifica el Domain Master Browser.

* **[domain_logons]** = Permite SAMBA a proveer NETWORK LOGON para Windows.

* **[logon_script]** = Ejecuta un script NETLOGON.

* **[logon_path]** = Especifica el PROFILE del usuario.

```
; security = user
; passdb backend = tdbsam
; domain master = yes
; domain logons = yes
# the following login script name is determined by the machine name
# (%m):
; logon script = %m.bat
# the following login script name is determined by the UNIX user used:
; logon script = %u.bat
; logon path = \\%L\Profiles\%u
# use an empty path to disable profile support:
; logon path =
# various scripts can be used on a domain controller or a stand-alone
# machine to add or delete corresponding UNIX accounts:
; add user script = /usr/sbin/useradd "%u" -n -g users
; add group script = /usr/sbin/groupadd "%g"
; add machine script = /usr/sbin/useradd -n -c "Workstation (%u)" -M -d /nohome -s
/bin/false "%u"
; delete user script = /usr/sbin/userdel "%u"
; delete user from group script = /usr/sbin/userdel "%u" "%g"
; delete group script = /usr/sbin/groupdel "%g"
```

### DOMAIN MEMBERS

* **[security]** = domain / ads

* **[passdb_backend]** = tdbsam

* **[realm]** = yes --> Security = server. Especifica que AD forma parte de algo.

* **[password_server]** = Sólo se usa si hay security = server.

```
; security = domain
; passdb backend = tdbsam
; realm = MY_REALM
; password server = <NT-Server-Name>
```

### BROWSER CONTROL OPTIONS

* **[local_master]** = no --> SAMBA no se convierte en MASTER BROWSER. Si es YES --> Hay ELECCIONES.

* **[OS_LEVEN]** = Determina la precedencia del Servidor unas ELECCIONES de MASTER BROWSER.

* **[preferred_master]** = yes --> Fuerza unas ELECCIONES DE MASTER BROWSER.

```
; local master = no
; os level = 33
; preferred master = yes
```

### NAME RESOLUTION

* **[wins_support]** = yes --> NMBD habilita WINS en el SERVIDOR.

* **[wins_server]** = Dice a NMBD que sea un cliente WINS

* **[wins_proxy]** = yes --> SAMBA responde queries de clientes WINS con el proxy capado.

* **[dns_proxy]** = yes --> SAMBA intente resolver el nombre de la NetBIOS via DNS..

```
; wins support = yes
; wins server = w.x.y.z
; wins proxy = yes
; dns proxy = yes
```

------------------------------------------------------------------------

#### Role Standalone

**testparm**

**Server role: ROLE_STANDALONE**


```
[root@portatil samba]# testparm
Load smb config files from /etc/samba/smb.conf
rlimit_max: increasing rlimit_max (1024) to minimum Windows limit (16384)
Processing section "[homes]"
Processing section "[printers]"
Processing section "[public]"
Processing section "[documentacio]"
Processing section "[repositori]"
Loaded services file OK.
Server role: ROLE_STANDALONE
Press enter to see a dump of your service definitions
```

```
[global]
      workgroup = GRUPM06
      netbios name = SMBSERVER
      server string = edt - Samba Server Version %v
      log file = /var/log/samba/log.%m
      max log size = 50
      wins support = Yes
      idmap config * : backend = tdb
      cups options = raw
[homes]
      comment = Home Directories
      read only = No
      browseable = No

[printers]
      comment = All Printers
      path = /var/spool/samba
      printable = Yes
      print ok = Yes
      browseable = No

[public]
      comment = Public Stuff
      path = /var/lib/samba/shares/public
      read only = No
      guest ok = Yes

[documentacio]
      comment = System Documentation
      path = /var/lib/samba/shares/samba-docs
      guest ok = Yes

[repositori]
      comment = Repositori de dades
      path = /var/lib/samba/shares/repositori
      write list = +staff
      read only = No
      guest ok = Yes
```

```
[root@portatil samba]# smbclient -U% -L localhost
Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.6.12-1.fc17]
Sharename Type Comment
--------- ---- -------
IPC$ IPC IPC Service (edt - Samba Server Version 3.6.12-1.fc17)
repositori Disk Repositori de dades
documentacio Disk System Documentation
public Disk Public Stuff
Cups-PDF Printer Cups-PDF
ClassPDF Printer Classe PF printers

Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.6.12-1.fc17]

Server Comment
--------- -------
SMBSERVER edt - Samba Server Version 3.6.12-1.fc17

Workgroup Master
--------- -------
GRUPM06 SMBSERVER
```

```
[pere@portatil ~]$ smbtree
Enter pere's password:
GRUPM06
\\SMBSERVER edt - Samba Server Version 3.6.12-1.fc17
\\SMBSERVER\ClassPDF Classe PF printers
\\SMBSERVER\Cups-PDF Cups-PDF
\\SMBSERVER\public Public Stuff
\\SMBSERVER\documentacio System Documentation
\\SMBSERVER\repositori Repositori de dades
\\SMBSERVER\IPC$ IPC Service (edt - Samba Server …..fc17)

```

------------------------------------------------------------------------

#### Role PDC Domain Server

**Server role: ROLE_DOMAIN_PDC**

```
[root@c2ae73d0f616 /]# testparm
Load smb config files from /etc/samba/smb.conf
Processing section "[homes]"
Processing section "[printers]"
Processing section "[documentation]"
Processing section "[manpages]"
Processing section "[public]"
Processing section "[privat]"
Loaded services file OK.
WARNING: You have some share names that are longer than 12 characters.
These may not be accessible to some older clients.
(Eg. Windows9x, WindowsMe, and smbclient prior to Samba 3.0.)
Server role: ROLE_DOMAIN_PDC
```

------------------------------------------------------------------------

## Repaso de órdenes CLIENTE

------------------------------------------------------------------------

### SMBCLIENT

```
]$ smbclient -L smbserver
Enter unknowns's password:
Anonymous login successful

Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.6.12-1.fc17]
Sharename Type Comment
--------- ---- -------
public Disk Public Stuff
documentacio Disk System Documentation
repositori Disk Repositori de dades
IPC$ IPC IPC Service (edt - Samba Server Version 3.6.12-1.fc17)
Cups-PDF Printer Cups-PDF
ClassPDF Printer Classe PF printers

Anonymous login successful

Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.6.12-1.fc17]
Server Comment
SMBSERVER edt - Samba Server Version 3.6.12-1.fc17
Workgroup Master
GRUPM06 SMBSERVER
```

------------------------------------------------------------------------

#### Usuarios autenticados

```
[pere@client ~]$ smbclient //smbserver/public
Enter pere's password:
session setup failed: NT_STATUS_LOGON_FAILURE
```
```
[root@smbserver samba]# smbpasswd -a pere
New SMB password:
Retype new SMB password:
Added user pere.
```
```
[pere@clientl ~]$ smbclient //smbserver/public
Enter pere's password:
Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.6.12-1.fc17]
smb: \>
```
```
[pau@client ~]$ smbclient //smbserver/public
Enter pau's password:
session setup failed: NT_STATUS_LOGON_FAILURE
```
```
[pau@client ~]$ smbclient //smbserver/public -U guest
Enter guest's password:
Anonymous login successful
Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.6.12-1.fc17]
smb: \>
```

```
[pere@client ~]$ smbclient //smbserver/documentacio
Enter pere's password:
Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.6.12-1.fc17]
smb: \> quit
```

```
[pere@client ~]$ smbclient //smbserver/documentacio pere
Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.6.12-1.fc17]
smb: \> quit

```

```
[pere@client ~]$ smbclient //smbserver/documentacio -U pere%pere
Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.6.12-1.fc17]
smb: \> quit

```

------------------------------------------------------------------------

#### Órdenes desatendidas

```
$ smbclient //smbserver/public -c "ls " -U pere%pere | grep "^ " | cut -d ' ' -f 3 - | sort
```

```
$ alias smbls='smbclient //smbserver/public -c \"ls \" -U pere%pere | grep "^ " | cut -d\ -f 3 - | sort

$ smbls
Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.6.12-1.fc17]
.
..
A05-14-serveisxarxa.pdf
activitats_asix_m06_uf1_nf5_2014-2015.pdf
```

```
smbls( )
{
share=`echo $1 | cut -d '/' -f '1-4'`
dir=`echo $1 | cut -d '/' -f '5-'`
smbclient $share -c "cd $dir; ls" -A ~/.smbpw | \
grep "^ " | cut -d ' ' -f 3 - | sort
}
```


------------------------------------------------------------------------

#### Shares Backups

```
[pere@client ~]$ smbclient //smbserver/public -U pere%pere -Tc public.tar
Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.6.12-1.fc17]
159579 ( 3315,7 kb/s) \A05-14-serveisxarxa.pdf
66227 (64674,8 kb/s) \activitats_asix_m06_uf1_nf5_2014-2015.pdf
tar: dumped 2 files and directories
Total bytes written: 226304
```

```
[pere@client ~]$ ll public.tar
-rw-r--r-- 1 pere pere 228352 15 nov 19:11 public.tar
```

```
[pere@client ~]$ tar tvf public.tar
-rw-r--r-- 0/0 159579 2014-11-15 17:21 ./A05-14-serveisxarxa.pdf
-rw-r--r-- 0/0 66227 2014-11-15 17:15 ./activitats_asix_m06_uf1_nf5_2014-2015.pdf
```

```
[pere@client ~]$ smbclient //smbserver/public -U pere%pere
Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.6.12-1.fc17]
smb: \> tarmode full hidden system quiet
tarmode is now full, system, hidden, noreset, quiet
smb: \> tar c public2.tar
tar: dumped 2 files and directories
Total bytes written: 226304
smb: \> quit
```

```
[pere@client ~]$ ll public2.tar
-rw-r--r-- 1 pere pere 228352 15 nov 19:17 public2.ta
```

------------------------------------------------------------------------

### CIFS - SMBFS

```
# apt-get install cifs-utils
```


```
[root@client ~]# mount -t cifs //127.0.01/public /mnt -o user=pere,password=pere

[root@client ~]# mount | grep cifs
//127.0.01/public on /mnt type cifs
(rw,nosuid,nodev,noexec,relatime,vers=1.0,sec=ntlmssp,cache=strict,unc=\\127.0.01\public,
username=pere,domain=SMBSERVER,uid=0,noforceuid,gid=0,noforcegid,addr=127.0.0.1,u
nix,posixpaths,serverino,acl,rsize=1048576,wsize=65536,actimeo=1)

[root@client ~]# ls /mnt/
A05-14-serveisxarxa.pdf activitats_asix_m06_uf1_nf5_2014-2015.pdf

[root@client ~]# umount /mnt
```

```
# mount -t cifs //127.0.01/public /mnt -o guest
# mount -t cifs //127.0.01/public /mnt -o user=pere,password=pere
# mount -t cifs //127.0.01/public /mnt -o credentials=file_passwd.txt
# mount -t cifs //127.0.01/public /mnt -o user=pere,password=pere,\
uid=pere,gid=pere,file_mode=0664,dir_mode=0775
```


```
[root@client ~]# mount -t cifs //127.0.01/public /mnt -o
guest,uid=pere,gid=pere,file_mode=0644,dir_mode=0755

[root@client ~]# uname -a > /mnt/uname.txt

[root@client ~]# ls -la /mnt/
drwxrwxrwx 2 pere pere 0 15 nov 19:56 .
drwxr-xr-x. 24 root root 4096 15 nov 14:04 ..
-rw-rw-r-- 1 pere pere 159579 15 nov 17:21 A05-14-serveisxarxa.pdf
-rw-rw-r-- 1 pere pere 66227 15 nov 17:15 activitats_asix_m06_uf1_nf5_2014-2015.pdf
-rw-r--r-- 1 pere pere 113 15 nov 19:53 uname.txt

[root@client ~]# mkdir /mnt/noudir

[root@portatil samba]# ls -ld /mnt/noudir/
drwxr-xr-x 2 pere pere 0 15 nov 19:59 /mnt/noudir/
```



------------------------------------------------------------------------

#### Múltiples Samba Servers

```
[pere@client ~]$ smbtree
Enter pere's password:
GRUPM06
   \\SMBSERVER edt - Samba Server Version 3.6.12-1.fc17
      \\SMBSERVER\ClassPDF Classe PF printers
      \\SMBSERVER\NullPrinter-01 Printer /dev/null
      \\SMBSERVER\ClassNulls Classe de NullPrinters
      \\SMBSERVER\ClassAll Classe amb totes les impressores
      \\SMBSERVER\NullPrinter-02 Priner /dev/null
      \\SMBSERVER\Virtual_PDF_Printer Virtual PDF Printer
      \\SMBSERVER\Cups-PDF Cups-PDF
      \\SMBSERVER\public Public Stuff
      \\SMBSERVER\documentacio System Documentation
      \\SMBSERVER\repositori Repositori de dades
      \\SMBSERVER\IPC$ IPC Service (edt - Samba Version 3.6.12-1.fc17)
   
   \\SMBHP1 edt - Samba Server Version 3.4.9-60.fc12
      \\SMBHP1\IPC$ IPC Service (edt - Samba Server Version 3.4.9-60.fc12)
      \\SMBHP1\hprepositori Repositori de dades
      \\SMBHP1\hpdocumentacio System Documentation
      \\SMBHP1\hppublic Public Stuff
```


```
[pere@client ~]$ smbclient -L smbhp1
Enter pere's password:
Anonymous login successful
Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.4.9-60.fc12]
   Sharename Type Comment
   hppublic Disk Public Stuff
   hpdocumentacio Disk System Documentation
   hprepositori Disk Repositori de dades
   IPC$ IPC IPC Service (edt - Samba Server Version 3.4.9-60.fc12)
Anonymous login successful
Domain=[GRUPM06] OS=[Unix] Server=[Samba 3.4.9-60.fc12]
   Server Comment
   SMBHP1 edt - Samba Server Version 3.4.9-60.fc12
   SMBSERVER edt - Samba Server Version 3.6.12-1.fc17
   Workgroup Master
   GRUPM06 SMBSERVER
```


### EJEMPLO DE M06 ASO SAMBA WORKGROUP --> MASTER BROWSER

```
# -----------------------------------------------------------------------------------------------
# Example M06-ASO configuration: samba workgroup => master browser
# [global] -----------------------------------------------------------------------------------------------
      workgroup = GRUPM06
      server string = edt - Samba Server Version %v
      netbios name = smbserver
      encrypt passwords = yes
      wins support = yes
      read only = no
      local master = yes
      os level = 34
      preferred master = yes
# -----------------------------------------------------------------------------------------------------
# Example M06-ASO configuration: samba workgroup => member, no master
# [global] -------------------------------------------------------------------------------------------------------
      workgroup = GRUPM06
      server string = edt - Samba Server Version %v
      netbios name = smbhp1
      encrypt passwords = yes
      wins support = no
      read only = no
      # local master = no
      # os level = 33
      # preferred master = no

```


------------------------------------------------------------------------

## Prácticas

* Muntar dins dels homes dels usuaris un altre home (com a classe) via samba.
Cal instal·lar els paquets samba i cifs-utils-6.7-1.fc24.x86_64
Configurar pam_mount.conf.xml: <volume user="*" fstype="cifs" server="samba"
path="%(USER)" mountpoint="~/%(USER)" />

```
[root@host docker]# su - local01
[local01@host ~]$ su - anna
pam_mount password:

[anna@host ~]$ ll
total 0
drwx------+ 2 anna alumnes 0 Dec 14 18:31 anna

[anna@host ~]$ mount -t cifs
//samba/anna on /tmp/home/anna/anna type cifs
(rw,relatime,vers=1.0,cache=strict,username=anna,domain=,uid=5002,forceuid,gid=600,force
gid,addr=172.21.0.2,unix,posixpaths,serverino,mapposix,acl,rsize=1048576,wsize=65536,ech
o_interval=60,actimeo=1)

```

------------------------------------------------------------------------

### Práctica 1: Homes Samba

------------------------------------------------------------------------

### Práctica 2: LDAP + SAMBA + PAM

Usant el **servidor LDAP** amb els usuaris habituals: 

   * En servidor SAMBA que reconeix els usuaris de LDAP.
   
   * Un host PAM que permet autenticació local i LDAP. 
   
   * Als usuaris locals es munta undirectori tmp de tmpfs de 100M. 
   
   * Als usuaris LDAP es munta el seu home dins del home via samba

------------------------------------------------------------------------

## Práctica: SAMBA + LDAP + PAM

## Imatges:
   
   * keshikid03/samba21:base_vFinal 
   
      * Servidor SAMBA amb usuaris locals i usuaris LDAP (unix). 
      
      * Es creen comptes d'usuari samba de usuaris locals i de alguns dels usuaris ldap (no tots). 
      
      *Es creen també els directoris home dels usuaris de ldap i se'ls assigna la pripietat/grup pertinent. 
      
      * Finalment s'exporten els shares d'exemple usuals i els [homes] dels usuaris samba. 
      
      * D'aquesta manera un hostpam (amb ldap) pot muntar els homes dels usuaris (home dins home) usant samba.

   * keshikid03/ldap21:group 
   
      * Incorpora els posixGroup dels usuaris (per memberUid).

   * keshikid03/pam21:ldap 
   
      * Host pam amb authenticació ldap. 
      
      * Utilitza l'ordre authconfig per configurar l'autenticació i a més a més crea els home dels usuaris i munta un tmpfs als usuaris. Atenció, per poder realitzar el mount cal que el container es generi amb l'opció --privileged. 
      
      * Posar en lloc d’aquest preferim usar el edtasixm06/hostpam:18homenfs



## Arquitectura

Per implementar un host amb usuaris unix i ldap on els homes dels usuaris es muntin via samba de un servidor de disc extern cal:

   * **2hisx** Una xarxa propia per als containers implicats.

   * **ldap21:group** Un servidor ldap en funcionament amb els usuaris de xarxa.

   * **samba21:base_vFinal** Un servidor samba que exporta els homes dels usuaris com a shares via [homes] Caldrà fer les tasques següents en el servidor samba:

      ○ **Usuaris unix** Samba requereix la *existència* de usuaris unix. Per tant caldrà disposar dels *usuaris unix*, poden ser locals o de xarxa via LDAP. 
      
      Així doncs, el *servidor samba* ha d'estar *configurat* amb *nscd i nslcd* per *poder accedir al ldap*.

      Amb *getent* s'han de poder llistar tots els usuaris i grups de xarxa.

      ○ **homes** Cal que els usuaris tinguin un directori home. Els usuaris unix local ja en tenen en crear-se l'usuari, però els *usuaris LDAP* no. 
      
      Per tant cal crear el directori *home dels usuaris ldap* i assignar-li la propietat i el grup de l'usuari
      apropiat.

      ○ **Usuaris samba** 
         
         * Cal **crear els comptes d'usuari samba** (recolsats en l'existència del mateix usuari **unix**). 
         
         * Per a **cada usuari samba** els pot crear amb **smbpasswd** el compte d'usuasi samba assignant-li el password de samba. 
         
         * Convé que sigui el mateix que el de *ldap* per tal de que en fer login amb un sol password es validi l'usuari (auth de *pam_ldap.so*) i es munti el home via samba (*pam_mount.so*). 
         
         * Samba pot desar els seus usuaris en una base de dades local anomenada **tdbsam** o els pot desar en un servidor ldap usant com a backend **ldapsam**. 
         
         * El mecanisme més simple és usar **tdbsam** i **smbpasswd** i **pdbedit** com a utilitats.


   * **pam21:ldap** Un hostpam configurat per accedir als usuaris **locals** i **ldap** i que usant **pam_mount.so** munta dins del home dels usuaris un home de xarxa via samba. 
   
      * Cal configurar **/etc/security/pam_mount.conf.xml** per muntar el recurs samba dels [homes].

### EJECUCIÓN

```
docker network create 2HISX

docker run --rm --name ldap.edt.org -h ldap.edt.org -P 389:389 --net 2hisx -d keshikid03/ldap21:group

docker run --rm --name pam.edt.org-h pam.edt.org --net 2hisx  --privileged -it keshikid03/pam21:ldap /bin/bash

docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisx -p 445:445 -p 139:139 --privileged -d keshikid03/samba21:base_vFinal
```

### CONFIGURACIÓN CLAVE

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
      ; valid users = %S
      ; valid users = MYDOMAIN\%S
```

### CONFIGURACÓN DE PAM21:LDAP --> PAM.MOUNT.CONF

* /etc/security/pam_mount.conf.xml

```
<
   volume user="*" 
   fstype="cifs" 
   server="smb.edt.org" 
   path="%(USER)" 
   mountpoint="~/%(USER)"
/>
```

### EJEMPLO 1 PAM21:LDAP

```
[root@host docker]# su - local01

[local01@host ~]$ su - anna
pam_mount password:

[anna@host ~]$ ll
total 0
drwxr-xr-x+ 2 anna alumnes 0 Dec 14 20:27 anna

[anna@host ~]$ mount -t cifs
//samba2/anna on /tmp/home/anna/anna type cifs
(rw,relatime,vers=1.0,cache=strict,username=anna,domain=,uid=5002,forceuid,gid=600,force
gid,addr=172.21.0.2,unix,posixpaths,serverino,mapposix,acl,rsize=1048576,wsize=65536,ech
o_interval=60,actimeo=1)

```

### EJEMPLO 2 PAM21:LDAP

```
#! /bin/bash
# @edt ASIX M06 2018-2019
# instal.lacio
# Creacio usuaris locals
groupadd localgrp01
groupadd localgrp02
useradd -g users -G localgrp01 local01
useradd -g users -G localgrp01 local02
useradd -g users -G localgrp01 local03
useradd -g users -G localgrp02 local04
useradd -g users -G localgrp02 local05
useradd -g users -G localgrp02 local06
echo "local01" | passwd --stdin local01
echo "local02" | passwd --stdin local02
echo "local03" | passwd --stdin local03
echo "local04" | passwd --stdin local04
echo "local05" | passwd --stdin local05
echo "local06" | passwd --stdin local06
# Activar nscd, nslcd, nsswitch (lligar getent amb lsap)
#bash /opt/docker/auth.sh
cp /opt/docker/nslcd.conf /etc/nslcd.conf
cp /opt/docker/ldap.conf /etc/openldap/ldap.conf
cp /opt/docker/nsswitch.conf /etc/nsswitch.conf
#cp /opt/docker/system-auth-edt /etc/pam.d/system-auth-edt
#cp /opt/docker/pam_mount.conf.xml /etc/security/pam_mount.conf.xml
#ln -sf /etc/pam.d/system-auth-edt /etc/pam.d/system-auth
/usr/sbin/nslcd && echo "nslcd Ok"
/usr/sbin/nscd && echo "nscd Ok"
# Crear els homes dels usuaris de LDAP (crear-omplir-chown)
mkdir /tmp/home
mkdir /tmp/home/pere
mkdir /tmp/home/pau
mkdir /tmp/home/anna
mkdir /tmp/home/marta
mkdir /tmp/home/jordi
mkdir /tmp/home/admin
cp README.md /tmp/home/pere
cp README.md /tmp/home/pau
cp README.md /tmp/home/anna
cp README.md /tmp/home/marta
cp README.md /tmp/home/jordi
cp README.md /tmp/home/admin
chown -R pere.users /tmp/home/pere
chown -R pau.users /tmp/home/pau
chown -R anna.alumnes /tmp/home/anna
chown -R marta.alumnes /tmp/home/marta
chown -R jordi.users /tmp/home/jordi
chown -R admin.wheel /tmp/home/admin
# Generar dos directoris de shares samba d’exemple: public i privat
mkdir /var/lib/samba/public
chmod 777 /var/lib/samba/public
cp /opt/docker/* /var/lib/samba/public/.
mkdir /var/lib/samba/privat
#chmod 777 /var/lib/samba/privat
cp /opt/docker/smb.conf /etc/samba/smb.conf
cp /opt/docker/*.md /var/lib/samba/privat/.
# Usuaris locals super3 unix i samba
useradd patipla
useradd lila
useradd roc
useradd pla
echo -e "patipla\npatipla" | smbpasswd -a patipla
echo -e "lila\nlila" | smbpasswd -a lila
echo -e "roc\nroc" | smbpasswd -a roc
echo -e "pla\npla" | smbpasswd -a pla
# Crear els comptes Samba dels usuaris LDAP
echo -e "pere\npere" | smbpasswd -a pere
echo -e "pau\npau" | smbpasswd -a pau
echo -e "anna\nanna" | smbpasswd -a anna
echo -e "marta\nmarta" | smbpasswd -a marta
echo -e "jordi\njordi" | smbpasswd -a jordi
echo -e "admin\nadmin" | smbpasswd -a admin

```

# En resum:
● Cal disposar d’usuaris unix (locals o de LDAP)
● En base als usuaris unix es creen els de SAMBA (el nom es el que fa el lligam al UID de
unix).
● Cal crear els homes dels usaris LDAP (no en tenen) i assignar apropiadament el
propietari i grup.
● Et voilà!



---------

## PRÁCTICA PAM - LDAP - SAMBA en AWS Educate

1. Iniciar sesión en https://awsacademy.instructure.com/

2. Irnos a Courses ..

	* Lab Foundation

		* Modules
		
			* AWS
			
3. Abrir AWS y luego EC2. 

4. Crear **"GROUP POLICES"**:

	* SAMBA vFinal:
	
		* PORT 445 i 139
	
	* SSH:
	
		* PORT 22
	
	* LDAP Group:
	
		* PORT 389
	
	* PAM LDAP: (Client, conté la RESOLUCIÓ via NSSWITCH)
	
5. Creamos una nueva Instancia de Debian. t2.Small de 4GB RAM.

6. Seleccionamos nuestro Group Policty

7. Nos descargamos nuestra clave privada RSA.

8. Abrimos una terminal de Debian/Ubuntu.

9. Nos conectamos con la ip pública **admin@ip-publica**.

<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS0.PNG" />   
     
10. Nos descargamos e instalamos DOCKER. 

*https://chachocool.com/como-instalar-docker-en-debian-10-buster/*

11. Clonamos el GIT de nuestros repositorios SAMBA, LDAP y PAM en AWS.

12. Creamos las máquinas SAMBA:base_vFinal, PAM:ldap, LDAP:group.

13. Desplegamos las máquinas.


```
sudo docker network create 2hisx

sudo docker run --rm --name ldap.edt.org -h ldap.edt.org -p 389:389 --net 2hisx -d keshikid03/ldap21:group

sudo docker run --rm --name pam.edt.org -h pam.edt.org --net 2hisx  --privileged -it keshikid03/pam21:ldap /bin/bash

sudo docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisx -p 445:445 -p 139:139 --privileged -d keshikid03/samba21:base_vFinal bash
```

	13.1. Probamos que funcione LDAP:Group desde AWS (Modo Detach):
	
		* sudo docker run --rm --name ldap.edt.org -h ldap.edt.org -p 389:389 --net 2hisx -d keshikid03/ldap21:group
	
		* Cambiamos el /etc/ldap/ldap.conf
		
			* dc=edt,dc=org
			
			* ldap://ldap.edt.org
		
		* Modificamos el /etc/host --> [ip_docker] [nom_host_ldap]
		
		* Instalamos el ldap-utils
		
		* Verificamos que funciona
		
<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS1.PNG" /> 

	13.2 Probamos que funcione desde el PAM:Ldap desde AWS (Modo Interactive):
	
		* sudo docker run --rm --name pam.edt.org -h pam.edt.org --net 2hisx  --privileged -it keshikid03/pam21:ldap /bin/bash

		* bash startup.sh
		
		* realizamos un ldapsearch -x -LLL
		
<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS2.PNG" /> 
		
		* modificamos el /etc/security/pam_mount.conf.xml *NOT YET AFTER SAMBA*
	
	13.3 Probamos que funcione el SAMBA desde AWS (Modo interactive).
	
		* sudo docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisx -p 445:445 -p 139:139 --privileged -d keshikid03/samba21:base_vFinal
		
		* Modificamos un mom para que sea interactivo, el startup.sh y le quitamos el -F
		
		* Hacemos bash startup.sh
		
<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS3.PNG" />
		
		* Hacemos un ldapsearch -x -LLL
		
<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS4.PNG" />


		* Volvemos al PAM:ldap y modificamos el pam_mount.conf.xml --> Tiene que apuntar a la IP de SAMBA (AWS).
		
<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS5.PNG" />

<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS6.PNG"  />

14. Comprobamos de forma LOCAL EN AWS.

	14.1. SMB.EDT.ORG --> su -l pere
	
<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS7.PNG"  />

	* Observamos que correctamente:
	
		1. Accedemos al USUARIO LDAP "PERE" y su home de LDAP es /tmp/home/%USER/
		
		2. El PAM_MOUNT.CONF.XML monta automáticamente vía TIPO "CIFS" de su home de SAMBA (~/%USER) (Alojado en smb.edt.org).
		
		3. Podemos probar de CREAR con el USUARIO PERE y vemos.
		
<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS8.PNG"  />

<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS9.PNG"  />
		
		4. Podemos probar de hacer un SMBCLIENT -U pere%pere -L smb.edt.org / smbclient -N -L smb.edt.org para ver los recursos y shares.
		
<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS10.PNG"  />

### VEMOS QUE FUNCIONA

14. En LOCAL abrimos una máquina PAM y las conectamos.

	* docker run --rm --name pam.edt.org -h pam.edt.org --net 2hisx  --privileged -it keshikid03/pam21:ldap /bin/bash
	
	* bash startup
	
	* Modificamos el /etc/hosts para que apunte a las máquinas de AWS
	
<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS11.PNG"  />

	* Probamos de hacer un ldapsearch -x -LLL
	
<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS12.PNG"  />

	
	* Volvemos al PAM:ldap y modificamos el pam_mount.conf.xml --> Tiene que apuntar a la IP PÚBLICA de SAMBA (AWS).
		
<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS13.PNG" />

	* Probamos de conectarnos con su -l pere y su -l marta
	
15. Probamos que funcione.


### Definitivamente funciona correctamente.

<img src="https://github.com/KeshiKiD03/samba21/blob/master/Photos/AWS14.PNG" />
	
### PRUEBAS y CORREGIR
	
* /etc/hosts (local)
```
52.91.228.34	pam.edt.org ldap.edt.org smb.edt.org
```
	
* getent passwd --> Verificamos que está el usaurio LDAP
```
unix01:x:1000:1000::/home/unix01:/bin/bash
unix02:x:1001:1001::/home/unix02:/bin/bash
unix03:x:1002:1002::/home/unix03:/bin/bash
pau:*:5000:100:Pau Pou:/tmp/home/pau:
pere:*:5001:100:Pere Pou:/tmp/home/pere:
anna:*:5002:600:Anna Pou:/tmp/home/anna:
marta:*:5003:600:Marta Mas:/tmp/home/marta:
jordi:*:5004:100:Jordi Mas:/tmp/home/jordi:
admin:*:10:10:Administrador Sistema:/tmp/home/admin:
user01:*:7001:610:user01:/tmp/home/1asix/user01:
user02:*:7002:610:user02:/tmp/home/1asix/user02:
user02:*:7003:610:user03:/tmp/home/1asix/user03:
user04:*:7004:610:user04:/tmp/home/1asix/user04:
user05:*:7005:610:user05:/tmp/home/1asix/user05:
user06:*:7006:611:user06:/tmp/home/2asix/user06:
user07:*:7007:611:user07:/tmp/home/2asix/user07:
user08:*:7008:611:user08:/tmp/home/2asix/user08:
user09:*:7009:611:user09:/tmp/home/2asix/user09:
user10:*:7010:611:user10:/tmp/home/2asix/user10:
	
```
	
* pam_mount.conf.xml (Local)

```
    <volume 
       user="*"     
       fstype="cifs" 
       server="smb.edt.org" 
       path="%(USER)" 
       mountpoint="~/%(USER)"
    />
	
```
	
* mount --> Verificamos el mount donde apunta
	
```
//smb.edt.org/pere on /tmp/home/pere/pere type cifs (rw,relatime,vers=3.1.1,cache=strict,username=pere,uid=5001,forceuid,gid=100,forcegid,addr=52.91.228.34,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1)
```
	
* smbclient -U pere%pere -L smb.edt.org
```
$ smbclient -U pere%pere -L smb.edt.org

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
	
* smbclient -U pere%pere //smb.edt.org
	
```
$ smbclient -U pere%pere //smb.edt.org/pere
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Fri Feb  4 10:44:04 2022
  ..                                  D        0  Fri Feb  4 10:21:55 2022
  feb4-22-Aaron                       D        0  Fri Feb  4 10:28:37 2022
  .bash_logout                        H      220  Wed Aug  4 20:25:59 2021
  .bashrc                             H     3526  Wed Aug  4 20:25:59 2021
  .profile                            H      807  Wed Aug  4 20:25:59 2021
  prova.txt                           N        0  Fri Feb  4 10:44:04 2022

		8062380 blocks of size 1024. 5070088 blocks available
	
```

------------------------------------------------------------------------
