#!/bin/sh
cd /opt/Aptonworks_PKI/CA/EasyRSA-3.0.8/

vars_dir="vars"
echo 'set_var EASYRSA_REQ_COUNTRY    "US"' > $vars_dir
echo 'set_var EASYRSA_REQ_PROVINCE    "California"' >> $vars_dir
echo 'set_var EASYRSA_REQ_CITY    "San Francisco"' >> $vars_dir
echo 'set_var EASYRSA_REQ_ORG    "Aptonworks"' >> $vars_dir
echo 'set_var EASYRSA_REQ_EMAIL    "noreply@Aptonworks.com"' >> $vars_dir
echo 'set_var EASYRSA_REQ_OU        "Aptonworks"' >> $vars_dir

bash /opt/Aptonworks_PKI/CA/EasyRSA-3.0.8/easyrsa init-pki

#bash /opt/Aptonworks_PKI/CA/EasyRSA-3.0.8/easyrsa build-ca nopass -f
exec echo -e "Aptonworks\n"| bash ./easyrsa build-ca nopass -f

mkdir -p ../keys/
cp pki/ca.crt ../keys/
cp pki/private/ca.key ../keys/
mkdir -p /opt/Aptonworks_PKI/OVPN/keys/
cp /opt/Aptonworks_PKI/CA/keys/ca.crt /opt/Aptonworks_PKI/OVPN/keys/
cp /opt/Aptonworks_PKI/CA/keys/ca.crt /etc/openvpn/
