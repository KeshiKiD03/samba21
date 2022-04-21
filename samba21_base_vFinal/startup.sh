#! /bin/bash

# Creacio Usuaris

mkdir /var/lib/samba/public && chmod 777 /var/lib/samba/public
uname -a > /var/lib/samba/public/uname.txt

cp /opt/docker/ldap.conf /etc/ldap/ldap.conf
cp /opt/docker/nsswitch.conf /etc/nsswitch.conf
cp /opt/docker/nslcd.conf /etc/nslcd.conf

/usr/sbin/nscd
/usr/sbin/nslcd

bash /opt/docker/users_ldap.sh && echo "Password Success 100"

#groupadd WinAdmins
#groupadd WinUsers
#groupadd WinGuests
#groupadd WinBackupOperators
#groupadd WinRestoreOperators

#usermod -g WinAdmins -G WinUsers pere
#usermod -g WinBackupOperators -G WinUsers pau
#usermod -g WinRestoreOperators -G WinUsers anna

cp smb.alone.conf /etc/samba/smb.conf
#mkdir /run/smbd
/usr/sbin/smbd && echo "smb Active"
/usr/sbin/nmbd -F && echo "nmb Active"

testparm
