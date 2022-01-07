#! /bin/bash

# Creacio Usuaris
useradd -m -s /bin/bash unix01 # -m crea directorio y -s shell
useradd -m -s /bin/bash unix02
useradd -m -s /bin/bash unix03

# Posar Password
echo -e "unix01\nunix01\n" | passwd unix01
echo -e "unix02\nunix02\n" | passwd unix02
echo -e "unix03\nunix03\n" | passwd unix03

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

# Asegurar que funcione
getent passwd
getent group

# Interactiu
/bin/bash

