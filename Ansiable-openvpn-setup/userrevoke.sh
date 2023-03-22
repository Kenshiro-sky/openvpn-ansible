#!/bin/bash
cd /opt/Aptonworks_PKI/OVPN
/bin/bash ./easyrsa init-pki
if [ "$#" -eq 0 ] ; then
      echo "Enter the valid vpn user profile"
      exit
fi

if [ "$1" = "ssv1-ovpn-server" ]; then 
    echo "You are trying to revoke the OVPN Server Certtificate, which is not allowed - Try manually"
    exit 1
fi

cd /opt/Aptonworks_PKI/CA/EasyRSA-3.0.8/
grep -w "$1" pki/index.txt  | grep ^V > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Given vpn user name $1 profile not found, Exiting"
    exit
fi

exec echo -en "yes\n" | sh ./easyrsa revoke  $1  > /dev/null 2>&1
grep -w "$1" pki/index.txt  | grep ^R > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Somethine went wrong, Please check manually"
    exit 1
else
    echo "Given VPN profile $1 certificate Revoked successfully"

fi

grep -i crl-verify /etc/openvpn/server.conf > /dev/null 2>&1
if [ $? -ne 0 ]; then
    sed -i '8icrl-verify crl.pem' /etc/openvpn/server.conf
fi
#Revoke user cert and update openssl crl list and restart instances
/bin/bash ./easyrsa gen-crl > /dev/null 2>&1
cp /opt/Aptonworks_PKI/CA/EasyRSA-3.0.8/pki/crl.pem /etc/openvpn/
rm -f /opt/Aptonworks_PKI/OVPN/User_VPN_Profile/$1.ovpn
systemctl restart openvpn@server