# OpenVPN server and client setup using Ansible
### usage

This is an Ansible project which is used to set up OpenVPN server on ubuntu instance. We need to provide IP address of this instance with port 22 open as ansible internally uses SSH to do the setup. In this project, we first setup OpenVPN on instance and then create client ovpn file which is downloaded locally so we can use it with VPN client tool. You need to have ansible installed on your local machine from where you are running these commands. 

In roles/openvpn/vars/main.yml flie you can change like below mentioned
```yaml
---
server_public_ip: #<<provide your server ip here>>
push_route: #<<provide your push_route range here>>
server_ip_ranges: #<<provide ip ranges of vpc>>
```  
 provide ip address or hosts  

### This project has a ansible roles in different playbook:

1. openvpn role:  To create OpenVPN server setup
2. usergen role:  To create OpenVPN user 
3. userrevoke role:To revoke OpenVPN user


```playbook.yml``` is main ansible file which is executed by ansible command for setup OpenVPN.

Steps to execute this project:
1. Clone this project on your local machine
2. Start your ubuntu instance with port 22 open to be accessed from your local machine
4. attach a firewall udp port 1194 source range should be open like 0.0.0.0/0
5. Update inventory file with correct `IP address` of an ubuntu instance
6. update config file with your details
7. Export the configuration using following commands=>
    export ANSIBLE_CONFIG=/path of/ansible.cfg  #give the path to fill the command and exicute it
    echo "export ANSIBLE_CONFIG=/path of/ansible.cfg" >> ~/.profile  ##give the path to fill the command and exicute it to export config file
8. update client config file with your details details
. Execute Ansible command mentioned below:

Ansible command:

## For OpenVPN setup
  

```shell
 ansible-playbook playbook.yml
```

## For user creation
In roles/usergen/vars/main.yml flie you can change like below mentioned
```yml  
user_name: #<<proivde your username here for the user creation and ovpnfile>>
```
provide user name to create user  and  ``username.ovpn`` wil be dowload inside your ansible folder

use this command run `userrevoke` playbook
```shell
 ansible-playbook usergen.yml
``` 
## for userrevoke
In roles/userrevoke/vars/main.yml flie you can change like below mentioned
```yml  
user_name: #<<proivde your username here for the user creation and ovpnfile>>
```
use this command run `userrevoke` playbook
```shell
 ansible-playbook userrevoke.yml
``` 

More information about ansible can be found [here](https://docs.ansible.com/ansible_community.html).