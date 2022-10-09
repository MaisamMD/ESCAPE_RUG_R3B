#!/bin/bash

#Required
domain=ssl/

#Change to your company details
country=GB
state=Nottingham
locality=Nottinghamshire
organization=Jamescoyle.net
organizationalunit=IT
commonname=jhubnginx
email=administrator@anything.net

#Create the request
openssl req -new -x509 -days 365 -nodes -out ssl/myssl.crt -keyout ssl/myssl.key \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

echo "....................................."
echo "....................................."
echo "Key and Cert have been generated and saved in" $domain "directory"
