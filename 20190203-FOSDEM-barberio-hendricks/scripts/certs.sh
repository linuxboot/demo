#!/bin/bash

openssl genrsa  -out rootCA.key 4096
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=2001:db8:1::1"
openssl genrsa -out '2001:db8:1::1'.key 2048

CNF=/etc/pki/tls/openssl.cnf 
openssl req -new -sha256 \
	-key 2001\:db8\:1\:\:1.key \
	-subj "/C=US/ST=CA/O=MyOrg, Inc./CN=2001:db8:1::1" \
	-out '2001:db8:1::1'.csr \
	-addext "subjectAltName = 'IP:2001:db8:1:0:0:0:0:1'" -extensions  SAN -config <(printf "[SAN]\nsubjectAltName='IP:2001:db8:1:0:0:0:0:1'\n"| cat $CNF -)

openssl x509 -req -in 2001\:db8\:1\:\:1.csr \
	-CA rootCA.crt -CAkey rootCA.key -CAcreateserial \
	-out 2001\:db8\:1\:\:1.crt -days 500 -sha256 \
	-extfile <(printf "subjectAltName='IP:2001:db8:1:0:0:0:0:1'\n")




