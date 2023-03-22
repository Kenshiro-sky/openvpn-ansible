#!/bin/sh
cd /opt/Aptonworks_PKI/Server
cd EasyRSA-3.0.8/
servername="vpn-server"
#Please set this variable manually

if [ -f "pki/private/"$servername".key" ]; then
    echo "Already Server Certificate Key file exists, Exiting. Please check manually and clear pki/private/"$servername".key"
    exit
fi

/bin/bash ./easyrsa init-pki  
# This step only required upon setting up first time server Cert. If you want to issue more server cert then disable this.

#Generate CSR Request
/bin/bash ./easyrsa --batch --req-cn="$servername" gen-req "$servername" nopass >> /dev/null 2>&1

mkdir -p ../keys/
cp pki/private/"$servername".key ../keys/
cp pki/reqs/"$servername".req ../keys/
cp pki/reqs/"$servername".req /tmp/

#Get Server CSR Signed
cd /opt/Aptonworks_PKI/CA/EasyRSA-3.0.8/
/bin/bash ./easyrsa --batch import-req /tmp/"$servername".req "$servername"
/bin/bash ./easyrsa --batch sign-req server "$servername"
rm -f /tmp/"$servername".req 
cp pki/issued/"$servername".crt /opt/Aptonworks_PKI/Server/keys/

#Copy server keys to OpenVPN Configuration
cd /opt/Aptonworks_PKI/Server
cp keys/"$servername".key /etc/openvpn/server.key
cp keys/"$servername".crt  /etc/openvpn/server.crt

#Generate DH Key and Secret key for server and client OpenVPN
cd EasyRSA-3.0.8/
/bin/bash ./easyrsa gen-dh
cp pki/dh.pem ../keys/
cp pki/dh.pem /etc/openvpn/
ln -s /etc/openvpn/dh.pem /etc/openvpn/dh2048.pem
openvpn --genkey --secret ../keys/ta.key
cp ../keys/ta.key /etc/openvpn/ 