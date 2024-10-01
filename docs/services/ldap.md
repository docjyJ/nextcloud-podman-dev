# LDAP

The LDAP sample data is based on <https://github.com/rroemhild/podman-test-openldap> and extended with randomly generated users/groups. For details see [data/ldap-generator/](https://github.com/docjyj/nextcloud-podman-dev/tree/master/data/ldap-generator). LDAP will be configured automatically if the ldap container is available during installation.

Example users are: `leela fry bender zoidberg hermes professor`. The password is the same as the uid.

## Useful commands

- Run an LDAP search
  - `ldapsearch -x -H ldap://$(podman inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nextcloud_ldap_1) -D "cn=admin,dc=planetexpress,dc=com" -w admin -b "dc=planetexpress,dc=com" -s subtree <filter> <attrs>`
  - `podman compose exec ldap ldapsearch -H 'ldap://localhost' -D "cn=admin,dc=planetexpress,dc=com" -w admin -b "dc=planetexpress,dc=com" "(&(objectclass=inetOrgPerson)(description=*use*))"`
