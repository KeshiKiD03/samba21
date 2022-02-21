#!/bin/bash

fqdn="dc=shockware-gaming,dc=com"
organisation="Shockware Gaming S.A."
admin_pass_plain="aaron"
uri="ldapi://%2fvar%2frun%2fslapd%2fldapi/"

# ----------------------------------------------------------------

mkdir -p tmp
chmod 750 tmp

echo;echo "Installing packages"
aptitude -y install slapd ldap-utils ldapscripts

admin_pass=`slappasswd -s $admin_pass_plain -h {MD5}`

echo;echo "Base schemas"

ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/inetorgperson.ldif

echo;echo "Backend"

cat > tmp/backend.ldif << EOF
dn: cn=module,cn=config
objectClass: olcModuleList
cn: module
olcModulepath: /usr/lib/ldap
olcModuleload: back_hdb

dn: olcDatabase=hdb,cn=config
objectClass: olcDatabaseConfig
objectClass: olcHdbConfig
olcDatabase: {1}hdb
olcSuffix: $fqdn
olcDbDirectory: /var/lib/ldap
olcRootDN: cn=admin,$fqdn
olcRootPW: $admin_pass_plain
olcDbConfig: set_cachesize 0 2097152 0
olcDbConfig: set_lk_max_objects 1500
olcDbConfig: set_lk_max_locks 1500
olcDbConfig: set_lk_max_lockers 1500
olcDbIndex: objectClass eq
olcLastMod: TRUE
olcDbCheckpoint: 512 30

olcAccess: to attrs=userPassword by dn="cn=admin,$fqdn" write by anonymous auth by self write by * none
olcAccess: to attrs=shadowLastChange by self write by * read
olcAccess: to dn.base="" by * read
olcAccess: to * by dn="cn=admin,$fqdn" write by * read
EOF

ldapadd -Y EXTERNAL -H ldapi:/// -f tmp/backend.ldif

echo;echo "Frontend"

cat > tmp/frontend.ldif << EOF
dn: $fqdn
objectClass: top
objectClass: dcObject
objectclass: organization
o: $organisation
dc: $organisation
description: $organisation

dn: cn=admin,$fqdn
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword: $admin_pass_plain

dn: ou=people,$fqdn
objectClass: organizationalUnit
ou: people

dn: ou=groups,$fqdn
objectClass: organizationalUnit
ou: groups

dn: ou=machines,$fqdn
objectClass: organizationalUnit
ou: machines
EOF

ldapadd -x -D cn=admin,$fqdn -w $admin_pass_plain -f tmp/frontend.ldif

echo;echo "Indexes"

cat > tmp/indexes.ldif << EOF
dn: olcDatabase={1}hdb,cn=config
add: olcDbIndex
olcDbIndex: uid eq,pres,sub
olcDbIndex: uidNumber eq
olcDbIndex: gidNumber eq
olcDbIndex: memberUid eq
olcDbIndex: uniqueMember eq
EOF

ldapmodify -Y EXTERNAL -H ldapi:/// -f tmp/indexes.ldif

/etc/init.d/slapd restart

echo;echo "Authentication"

cat > /etc/ldap.conf << EOF
base $fqdn
uri $uri
ldap_version 3
#binddn
#bindpw
rootbinddn cn=admin,$fqdn
timelimit 5
bind_timelimit 5
pam_password md5
EOF

ln -fs ../ldap.conf /etc/ldap/ldap.conf

cat > /etc/ldapscripts/ldapscripts.conf << EOF
SERVER="$uri"
BINDDN="cn=admin,$fqdn"
#BINDPWDFILE="/etc/ldapscripts/ldapscripts.passwd"
BINDPWDFILE="/etc/ldap.secret"

SUFFIX="$fqdn"
GSUFFIX="ou=groups"
USUFFIX="ou=people"
MSUFFIX="ou=machines"

GIDSTART="10000"
UIDSTART="10000"
MIDSTART="20000"

CREATEHOMES="no"

PASSWORDGEN=""

RECORDPASSWORDS="no"
PASSWORDFILE="/var/log/ldapscripts_passwd.log"

LOGFILE="/var/log/ldapscripts.log"

TMPDIR="/tmp"

LDAPSEARCHBIN="/usr/bin/ldapsearch"
LDAPADDBIN="/usr/bin/ldapadd"
LDAPDELETEBIN="/usr/bin/ldapdelete"
LDAPMODIFYBIN="/usr/bin/ldapmodify"
LDAPMODRDNBIN="/usr/bin/ldapmodrdn"
LDAPPASSWDBIN="/usr/bin/ldappasswd"

GETENTPWCMD="getent passwd"
GETENTGRCMD="getent group"

GTEMPLATE=""
UTEMPLATE=""
MTEMPLATE=""
EOF

rm /etc/ldapscripts/ldapscripts.passwd

aptitude -y install libnss-ldap

echo -n $admin_pass_plain > /etc/ldap.secret
chmod 400 /etc/ldap.secret

auth-client-config -t nss -p lac_ldap

pam-auth-update

echo "session required pam_mkhomedir.so" > /etc/pam.d/common-session.new
cat /etc/pam.d/common-session >> /etc/pam.d/common-session.new
mv /etc/pam.d/common-session.new /etc/pam.d/common-session

#rm -rf tmp
