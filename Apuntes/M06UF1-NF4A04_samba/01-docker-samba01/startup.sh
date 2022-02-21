#! /bin/bash
/usr/bin/echo "starting nmbd"
/usr/sbin/nmbd && echo "ok"

/usr/bin/echo "starting smbd"
/usr/sbin/smbd && echo "ok"

