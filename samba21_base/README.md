# PAM

## @edt ASIX M06 2020-2021

* **keshikid03/samba21:base** Host de SAMBA BASE para practicar SHARES y USUARIOS SAMBA.

```
docker build -t keshikid03/samba21:base .

docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisx -p 445:445 -p 139:139 --privileged -it keshikid03/samba21:base /bin/bash
```

Para complementarlo, abrir un host de LDAP:GROUP
```
docker run --rm --name ldap.edt.org -h ldap.edt.org --net 2hisx -p 389:389 -d keshikid03/ldap21:group
```

