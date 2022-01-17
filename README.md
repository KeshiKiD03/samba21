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
docker run --rm --name ldap.edt.org -h ldap.edt.org --net 2hisx -d keshikid03/ldap21:groups

docker run --rm --name pam.edt.org -h pam.edt.prg --net 2hisx --privileged -it keshikid03/pam21:ldap /bin/bash
docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisx -p 445:445 -p 139:139 --privileged -d keshikid03/samba21:base_vFinal

```

#### INTERACTIU:
```
docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisx -p 445:445 -p 139:139 --privileged -it keshikid03/samba21:base_vFinal /bin/bash

```

 * **keshikid03/samba21:pam** Host amb un servidor samba que té usuaris unix locals, usuaris samba locals
   i usuaris de ldap. A aquests usuaris de ldap se'ls crea el compte de samba (hardcoded) i el seu home
   (hardcoded: cal crear, copiar skel i assignar permisos). exporta els homes dels usuaris via el
   share *[homes]*.
