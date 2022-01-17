# SAMBA server
## Aaron Andal ASIX M06-ASO 2021-2022

Imatges docker al DockerHub de [edtasixm06](https://hub.docker.com/u/edtasixm06/)

Documentació del mòdul a [ASIX-M06](https://sites.google.com/site/asixm06edt/)

ASIX M06-ASO Escola del treball de barcelona

### SAMBA Containers:

 * **keshikid03/samba21:base_vFinal** 

#### Documentació:
Executarem l'startup amb bash:

```
bash startup
```

Per temes de broadcast amb Windows, 'smbtree' pot no funcionar, llavors, farem la següent ordre desde el propi servidor per comprovar que esta funcionant tot, quan demani password, pulsem 'ENTER'.

```
smbclient -L localhost
smbclient -L smb
```

Iniciem sessió com a pere en el nostre client, llistem els recursos compartits i comprobem la connexió amb 'smbclient':

```
su - pere
smbclient -L 172.18.0.2
```

Entrem als recursos compartits desde l'usuari 'pere':

```
smbclient //172.18.0.2/doc
```

Per baixar-nos qualsevol document:

```
smbget smb://<IP>_<host>/<recurs>/<fitxer>
```

Per muntar directoris:

```
mount -t cifs -o <user> //<IP>/<path_origen> <destí>
```

Per accedir al server desde nautilus:

```
smb://<IP>
```

#### Configuració servidor:
Per crear usuaris samba per poder entrar als recursos compartits hem de fer:

```
echo -e "<passw>\n<passwd>" | smbpaswd -a -s <user>
```

Dins d'aquest fitxer: '/etc/samba/smb.conf', afegim un nou recurs permetent només que pugui entrar l'usauri 'rubeeenrg, pere':

```
[compartit]
	comment = Compartit de caca i pipi	# Comentari que apraeixerà a l'usauri quan faci 'smbclient'.
	path = /tmp/compartit	# Path que compartim
	browseable = yes	# Amb aquesta opció, ens permetrà que l'usuari pugui veure aquest recurs compartit.
	read only = yes		# Són els permisos que ens diu que només podrem llegir. 
	guest ok = yes		# Permet login amb 'anonymous' (guest = anonymous (windos)
	valid users = rubeeenrg, pere		# Només podrem entrar als recursos compartits amb aquests usuaris.
```



``` 
docker run --rm --name ldap.edt.org -h ldap.edt.org --net 2hisx -d keshikid03/ldap21:groups

docker run --rm --name pam.edt.org -h pam.edt.prg --net 2hisx --privileged -it keshikid03/pam21:ldap /bin/bash
docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisx -p 445:445 -p 139:139 --privileged -d keshikid03/samba21:base_vFinal

INTERACTIU:
docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisx -p 445:445 -p 139:139 --privileged -it keshikid03/samba21:base_vFinal /bin/bash
```

