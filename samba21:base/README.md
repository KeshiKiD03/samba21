# SAMBA @isx25633105 ASIX
# Curs 2021-2022

* **isx25633105/samba21:base:**
* Ordre per executar el container:
* Xarxa propia:

```
docker build -t keshikid03/samba21:base .
```

```
docker run --privilieged --rm --name samba.edt.org -h samba.edt.org --net 2hisx -d keshikid03/samba21:base
```

