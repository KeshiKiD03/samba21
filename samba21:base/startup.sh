#! /bin/bash

/opt/docker/install.sh && echo "Install Success 100"

# Creacio Usuaris
useradd -m -s /bin/bash unix01 # -m crea directorio y -s shell
useradd -m -s /bin/bash unix02
useradd -m -s /bin/bash unix03

# Creacio Usuaris SAMBA

useradd -m -s /bin/bash smbunix01
useradd -m -s /bin/bash smbunix02
useradd -m -s /bin/bash smbunix03


# Posar Password
echo -e "unix01\nunix01\n" | passwd unix01
echo -e "unix02\nunix02\n" | passwd unix02
echo -e "unix03\nunix03\n" | passwd unix03

# Posar Password a Usuaris SAMBA/UNIX

echo -e "smbunix01\nsmbunix01\n" | passwd smbunix01
echo -e "smbunix02\nsmbunix02\n" | passwd smbunix02
echo -e "smbunix03\nsmbunix03\n" | passwd smbunix03


# Posar Password a Usuaris SAMBA

echo -e "smbunix01\nsmbunix01\n" | smbpasswd -a smbunix01
echo -e "smbunix02\nsmbunix02\n" | smbpasswd -a smbunix02
echo -e "smbunix03\nsmbunix03\n" | smbpasswd -a smbunix03


# MArc
# AQUI AFEGIM EN LOCAL ELS COMPTES d'USUARI QUE PERMETREN QUE SAMBA DEIXI COMPARTIR RECURSOS
useradd pere
useradd pau
useradd anna

# UN COP CREATS ELS AFEGIM PQ TINGUIN ACCESSx AL SERVIDOR SAMBA 
echo -e "pere\npere" | smbpasswd -a -s pere
echo -e "pau\npau" | smbpasswd -a -s pau
echo -e "anna\nanna" | smbpasswd -a -s anna


# Afegir els grups

groupadd WinAdmins
groupadd WinUsers
groupadd WinGuests
groupadd WinBackupOperators
groupadd WinRestoreOperators
groupadd UserHomes

# -g GRUP principal, -G grup secundari

usermod -g WinAdmins -G WinUsers pere
usermod -g WinBackupOperators -G WinUsers pau
usermod -g WinRestoreOperators -G WinUsers anna
usermod -G UserHomes pau
usermod -G UserHomes pere
usermod -G UserHomes anna


# Copiar arxius necesaris
cp /opt/docker/ldap.conf /etc/ldap/ldap.conf
cp /opt/docker/login.defs /etc/login.defs
cp /opt/docker/nsswitch.conf /etc/nsswitch.conf
cp /opt/docker/nslcd.conf /etc/nslcd.conf
cp /opt/docker/pam_mount.conf.xml /etc/security/pam_mount.conf.xml
cp /opt/docker/common-auth /etc/pam.d/common-auth
cp /opt/docker/common-account /etc/pam.d/common-account
cp /opt/docker/common-password /etc/pam.d/common-password
cp /opt/docker/common-session /etc/pam.d/common-session

# Engegar dimonis necesaris
/usr/sbin/nscd
/usr/sbin/nslcd
/usr/sbin/smbd && echo "smb Active"
/usr/sbin/nmbd && echo "nmb Active"

# --

llistaUsers="pere marta anna pau pere jordi"
for user in $llistaUsers
do
  echo -e "$user\n$user" | smbpasswd -a $user
  line=$(getent passwd $user)
  uid=$(echo $line | cut -d: -f3)
  gid=$(echo $line | cut -d: -f4)
  homedir=$(echo $line | cut -d: -f6)
  echo "$user $uid $gid $homedir"
  if [ ! -d $homedir ]; then
    mkdir -p $homedir
    cp -ra /etc/skel/. $homedir
    chown -R $uid.$gid $homedir
  fi
done

# Asegurar que funcione
#getent passwd
#getent group

# Verificar SAMBA
testparm

# Interactiu
/bin/bash

