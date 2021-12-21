# /bin/bash
/opt/docker/install.sh && echo "Install succes"

useradd -m -s /bin/bash unix01
useradd -m -s /bin/bash unix02
useradd -m -s /bin/bash unix03
useradd -m -s /bin/bash lila
useradd -m -s /bin/bash roc
useradd -m -s /bin/bash patipla
useradd -m -s /bin/bash pla
echo -e "unix01\nunix01" | passwd unix01
echo -e "unix02\nunix02" | passwd unix02
echo -e "unix03\nunix03" | passwd unix03
echo -e "lila\nlila" | smbpasswd -a lila
echo -e "roc\nroc" | smbpasswd -a roc
echo -e "patipla\npatipla" | smbpasswd -a patipla
echo -e "pla\npla" | smbpasswd -a pla

cp /opt/docker/ldap.conf /etc/ldap/
cp /opt/docker/nsswitch.conf /etc/
cp /opt/docker/nslcd.conf /etc/
cp /opt/docker/common-session /etc/pam.d/
cp /opt/docker/common-auth /etc/pam.d/
cp /opt/docker/common-password /etc/pam.d/
cp /opt/docker/common-account /etc/pam.d/
/usr/sbin/smbd && echo "smb active"
/usr/sbin/nmbd -F && echo "nmb active"
/usr/sbin/nslcd
/usr/sbin/nscd
/bin/bash
