# https://en.wikibooks.org/wiki/OpenSSH/Client_Configuration_Files

### Create private and public keys (default -t rsa ???):
ssh-keygen
#.... The name-of-the-file
#.... No password for passwordless login

### Populate public key in a server for passwordless login
ssh-copy-id -i <name-of-the-file> user@hostname
# OR
cat ~/.ssh/id_rsa.pub | ssh user@host 'cat >> ~/.ssh/authorized_keys'


### To add the add the public key in hosts_knows for authentification (avoid warning and error)
echo  "hostname,ip-addr  $(cat <name-of-the-file.pub>)" >> ~/.ssh/known_hosts

### Encrypt the new entry If ~/.ssh/known_hosts is encrypted (HashKnownHosts=True) :
ssh-keygen -H
