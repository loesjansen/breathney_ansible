# Deployment instructions for VUB Breathney

# Clients (Breathney computers)

## Install Ubuntu

- Install Ubuntu 18.04.4 LTS (Desktop)
- User: **breathney**
- Password: **breathney**

## SSH

Install and start ssh: 

```
sudo apt-get install ssh          
sudo systemctl start ssh    
sudo systemctl enable ssh
```

Get interface and ip address for use in ansible hostfiles
```
ip a
```

# Server

## Install ansible (instructions for installation on Ubuntu)

Install ansible (latest version! > 2.9)

```
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
```

Download files from [https://github.com/loesjansen/breathney_ansible](https://github.com/loesjansen/breathney_ansible)

```
sudo apt update
sudo apt install git
git clone https://github.com/loesjansen/breathney_ansible
```

Edit files

- Add ip address and hostname to /etc/hosts
- Add hosts (breathney01, breathney02, …) to **breathney\_ansible/hosts**, list them under **[breathney]**
- Add a yml-file for every host, set the correct ip-address in each file
- Run ansible-playbook:
   ```ansible-playbook breathney\_ansible/breathney.yml -u breathney -k -K  ```
   Use arguments:  
        -u: remote user (in this case: breathney)  
        -k: ask password for connecting (if unchanged: breathney)  
        -K: ask become password (if unchanged: breathney)

*Remark:* -k and -K are only needed the 1st time you run ansible:
  -k: Configure ssh key (see next step below) or add your public key in ansible (see breathney\_ansible/roles/setup/tasks/users.yml).  
  -K: After running ansible-playbook the 1st time, breathney will be added to sudoers and you do not need to enter the password anymore.

*Remark:* the default passwords for breathney and breathneyfrontend can be changed in breathney\_ansible/roles/setup/tasks/users.yml (see “Change passwords” below).

## Configure ssh

Generate ssh key (without passphrase) and copy to all breathneys

```
ssh-keygen
ssh-copy-id breathney@breathney01
```
(Standard password = breathney)

# What does ansible configure?

We assign 2 roles in breathney_ansible/breathney.yml:
- setup
- frontend

## Setup

The general setup can be found in breathney_ansible/roles/setup/tasks/main.yml, it includes 4 files:

- packages.yml
- users.yml
- environment.yml
- settings.yml

### packages.yml

- Installs apt key
- Upgrades all packages
- Installs basic packages (list is defined in breathney\_ansible/roles/setup/vars/main.yml)
- Installs packages for network configuration

### users.yml en user.yml

- Installs zshell
- Adds users and groups
- Creates homedirs
- Configuration for users:
  - breathney (admin)
  - breathneyfrontend (user for autologin and running of frontend apps)
  - root

### environment.yml

- Sets locale
- Sets timezone
- Sets hostname
- Sets a static ip 
  - Is configured in the files in breathney_ansible/host_vars
  - The purpose of using a static ip is to continue the ansible configuration after reboot. Of course this will need to change when the computer is used on-site in a different network.

### settings.yml

Sound settings for use on a Raspberry Pi, the laptops have volume buttons. You may want to change this when using other machines.

## Frontend

Configuration for frontend settings: starting the computer with the ventilator program running in kiosk mode. 
Files can be found in: breathney\_ansible/roles/front/tasks

### main.yml

Installs packages for autologin.

### breathney.yml

- Installs and configures chromium. 
  The startup URL (**http://localhost:3001**) is configured in breathney\_ansible/group_vars/breathney.yml
- Installs arduino-mk
  This tool can be used to update the arduino code, should this ever be necessary.
- Sets udev rules for arduino (when connected it will appear as /dev/ventilator)
- Installs docker, downloads the configuration files from Github, and performs “docker-compose up”.

# Change passwords

To change the passwords for breathney and breathneyfrontend, add them to breathney_ansible/roles/setup/tasks/users.yml

To generate an encrypted password, use:

```ansible all -i localhost, -m debug -a "msg={{ 'new_breathney_password' | password_hash('sha512', 'mysecretsalt') }}```

