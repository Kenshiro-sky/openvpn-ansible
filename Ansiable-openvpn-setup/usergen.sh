#!/bin/bash
# cd /opt/Aptonworks_PKI/CA/EasyRSA-3.0.8/
# /bin/bash ./easyrsa init-pki 

KEYDIR=/opt/Aptonworks_PKI/OVPN/keys/
OUTPUTDIR=/opt/Aptonworks_PKI/OVPN/User_VPN_Profile
BASECONFIG=/opt/Aptonworks_PKI/OVPN/ovpn.conf
mkdir -p $OUTPUTDIR $KEYDIR
cd /opt/Aptonworks_PKI/Server/EasyRSA-3.0.8
#Req CSR for client Certificate
/bin/bash ./easyrsa --batch --req-cn="$1" gen-req $1 nopass 

cd /opt/Aptonworks_PKI/CA/EasyRSA-3.0.8
cp /opt/Aptonworks_PKI/Server/EasyRSA-3.0.8/pki/reqs/"$1".req /tmp/
cp /opt/Aptonworks_PKI/Server/EasyRSA-3.0.8/pki/reqs/"$1".req /opt/Aptonworks_PKI/OVPN/keys/
#Sign client Cert by root CA
/bin/bash ./easyrsa --batch import-req /tmp/"$1".req $1 
/bin/bash ./easyrsa --batch sign-req client $1 
rm -f /tmp/"$1".req 
# cd /opt/Aptonworks_PKI/CA/EasyRSA-3.0.8/pki
# mkdir issued
cd /opt/Aptonworks_PKI/OVPN
cp /opt/Aptonworks_PKI/Server/EasyRSA-3.0.8/pki/private/"$1".key /opt/Aptonworks_PKI/OVPN/keys/
cp /opt/Aptonworks_PKI/CA/EasyRSA-3.0.8/pki/issued/"$1".crt /opt/Aptonworks_PKI/OVPN/keys/
cp /opt/Aptonworks_PKI/Server/keys/ta.key /opt/Aptonworks_PKI/OVPN/keys/
cd /opt/Aptonworks_PKI/OVPN
# Generating Cliect OpenVPN Profiles
if [ ! -f "${KEYDIR}/${1}.crt" ]; then
    echo "Given user certificate not found"
    exit 1
else
    sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' "${KEYDIR}/${1}.crt" > "${KEYDIR}/${1}.crt1"
fi

cat ${BASECONFIG} \
    <(echo -e '\n<ca>') \
    ${KEYDIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEYDIR}/${1}.crt1 \
    <(echo -e '</cert>\n<key>') \
    ${KEYDIR}/${1}.key \
    <(echo -e '</key>\n<tls-auth>') \
    ${KEYDIR}/ta.key \
    <(echo -e '</tls-auth>') \
    > ${OUTPUTDIR}/${1}.ovpn

rm -f ${KEYDIR}/${1}.crt1 
echo "User $1 VPN Profile created and uploaded to file /opt/Aptonworks_PKI/OVPN/User_VPN_Profile/$1.ovpn "
