APUNTES IMPORTANTES PARA PAPEL

https://github.com/KeshiKiD03/samba21

https://www.alcancelibre.org/staticpages/index.php/como-samba-basico

https://www.youtube.com/watch?v=Vc17tzFiTzo

https://www.youtube.com/watch?v=_7TMluHVx4Y

https://gitlab.com/edtasixm06/m06-aso/-/tree/main/UF1_5_samba

pt3_permisos_i_control_access_samba.odt

OTROS APUNTES 

SAMBA - Open Source que usa el PROTOCOLO SMB/CIFS.

EJECUTABLES

/usr/sbin/smbd --> Ruta de daemon SMB 
/usr/sbin/nmbd --> Ruta de daemon NMB




# OPCIONES DE CONFIGURACION .

Netbios Name. Nombre del Server.

Workgrup: Dominio (Standalone o PDC).

    * Es un NetBIOS.

    * Los hosts tienen que estar en el mismo Dominio.

Server String: Descripción Server Samba.

SERVER STANDALONE: Sense Active Directory. Minimal security. Acceso todo / guest.

PDC: Servidor que controla Dominio o Grupo de Trabajo.

MASTER BROWSER: Administrador --> Gestiona Lista Workgroup.

BDC: Controlador Secundario.

---------------








CIFS - Common Internet File System.


Protocolo SMB. Server Message Block. Protocolo de Windows. Gestión de recursos de disco/imp.

    compartir.com y unidades red.

Puertos SAMBA.

SMBCLIENT: smbclient //nomserver/nomrecurs [-U guest] . Es como ftp.

   * Listado (ANONYMOUS / GUEST / USUARIO Identificado)

        * -N anonymous // smbclient -N -L smb.edt.org

        * -U usuario Samba // smbclient -U pere -L smb.edt.org

        * -L Listar // smbclient -L

        * % --> Permite no interactivo

   * Acceso (ANONYMOUS / GUEST / USUARIO Identificado)

        * -N anonymous // smbclient -N //smb.edt.org/recurso

        * -U usuario Samba // smbclient -U pere //smb.edt.org/recurso

        * smbclient //smb.edt.org/recurso

        *% --> Permite no interactivo


SMBGET: Tipo Wget. Descarga ficheros.

    * smbget smb://nomserver/ruta/recurso

SMBPASSWD: Crea usuarios Samba.

SMBTREE: Disco o impresion.

    * Listar todos los hosts

    * Listar todos los Workgroups/Dominios disponibles. smbtree -D

    * Listar servidores conocidos smbtree -S

NMBLOOKUP: Resuelve.

    * nmblookup -S nomserver

    * Netbios Name - Tienen que estar en la misma WORKGROUP. netbios name = Server01

MOUNT.CIFS

Nautilus.

Firefox.

Tipos de ROL:

   * Server Standalone.

   * PDC Controlador de Dominio Principal.

   * Master Browser.

   * BDC: Controlador Secundario.



NMB - Resolución de Windows 

    * WINS Support YES/NO


# MODELO DE SHARES DE HOST 

* RECURSO .

    * Sin Seguridad + Password generico + Read / write o read only. 

* USUARIO .

    * Lista de usuarios y Permisos asignados.

* Browseables o ocultos.

GLOBAL: 
    * WORKGROUP

    * NETBIOS NAME

    * PASSDB = tdbsam / ldapsam

    * NMBD - WINS SUPPORT: YES --> Realiza Resolución. Como DNS para Windows.

    * NMBD - WINS SUPPORT: NO --> Cliente WINS.

    *

    *

    *

    *

    *



SHARES: Recurso - red

    * PATH --> Ruta del Share.

    * COMMENT --> Comentario.
      
    * VOLUME --> 

    * READ ONLY [yes/no]--> Lectura SI - NO 

    * WRITE ONLY [yes/no]--> Escritura SI - NO

    * WRITABLE [yes/no]--> Escritura -Lectura SI - NO

    * READ LIST [userN]--> Lista users

    * WRITE LIST [userN]--> Lista users

    * GUEST OK = Acceso Guest

    * GUEST ONLY = Only Guest

    * VALID USERS = Lista users acceso OK

    * INVALID USERS = Lista users acceso DENY

    * BROWSEABLE = Print ?

    *
    
    *

    *

    *


a



PRACTICA LDAP + PAM + SAMBA

* Same NETWORK.

* --privileged (PAM) // EXPOSE 139 + 445 en SAMBA

* Creación de USUARIOS SAMBA e UNIX.

* Exportación de [homes] --> PAM_MOUNT.CONF.XML (PAM)

* Inició de sesión en PAM + VER si está HOME SAMBA.