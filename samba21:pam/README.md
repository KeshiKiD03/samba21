# SAMBA PAM @isx25633105 ASIX
# Curs 2021-2022

* **isx25633105/samba21:pam:**
* Ordre per executar el container:
* Xarxa propia:

```

docker build -t isx25633105/samba21:pam .

docker run --privileged --rm --name samba.edt.org -h samba.edt.org --net 2hisx -d isx25633105/samba21:pam
```

