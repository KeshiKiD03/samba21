  GNU nano 4.8                      users_ldap.sh                                 
#!/bin/bash
# Rubén Rodríguez García ASIX M06 2021-2022
# -----------------------------------------------

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
