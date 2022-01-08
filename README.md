# SAMBA
## @edt ASIX M06 2021-2022

Podeu trobar les imatges docker al Dockehub de [edtasixm06](https://hub.docker.com/u/edtasixm06/)

Podeu trobar la documentació del mòdul a [ASIX-M06](https://sites.google.com/site/asixm06edt/)


ASIX M06-ASO Escola del treball de barcelona

### Imatges:

* **keshikid03/samba21:base** Servidor SAMBA bàsic amb *shares* d'exemple.


#### Execució

```
docker run --rm --name samba -h samba --net sambanet -it edtasixm06/samba21:base 
```

 * **edtasixm06/samba21:pam** Host amb un servidor samba que té usuaris unix locals, usuaris samba locals
   i usuaris de ldap. A aquests usuaris de ldap se'ls crea el compte de samba (hardcoded) i el seu home
   (hardcoded: cal crear, copiar skel i assignar permisos). exporta els homes dels usuaris via el
   share *[homes]*.
