#! /bin/bash

/opt/docker/install.sh && echo "Install succes"

useradd -m -s /bin/bash lila
useradd -m -s /bin/bash roc
useradd -m -s /bin/bash patipla
useradd -m -s /bin/bash pla
echo -e "lila\nlila" | smbpasswd -a lila
echo -e "roc\nroc" | smbpasswd -a roc
echo -e "patipla\npatipla" | smbpasswd -a patipla
echo -e "pla\npla" | smbpasswd -a pla


/usr/sbin/smbd && echo "smb active"
/usr/sbin/nmbd -F && echo "nmb active"

