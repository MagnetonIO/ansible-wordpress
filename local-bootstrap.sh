#!/usr/bin/env bash

ANSIBLE_PROJECT=/ansible-wordpress/ansible

# Read args
for i in "$@"
do
case $i in
    -i=*|--inventory=*)
    INVENTORY="${i#*=}"
    ;;
    -p=*|--playbook=*)
    PLAYBOOK="${i#*=}"
    ;;
    -u=*|--user=*)
    REMOTE_USER="${i#*=}"
    ;;
    -c=*|--connection=*)
    CONNECTION="${i#*=}"
    ;;
    --default)
	# Set default args
    INVENTORY="stage"
    PLAYBOOK="site.yml"
    REMOTE_USER="root"
    CONNECTION="local"
    ;;
    *)
    ;;
esac
done

# Show args
echo INVENTORY = ${INVENTORY}
echo PLAYBOOK = ${PLAYBOOK}
echo REMOTE_USER = ${REMOTE_USER}
echo CONNECTION = ${CONNECTION}

# Install ansible
apt-get install -y software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update && apt-get -y upgrade
apt-get install -y ansible

# Install PHP  Repo
add-apt-repository -y ppa:ondrej/php

# Install MySQL repo
dpkg -i $ANSIBLE_PROJECT/mysql-apt-config_0.8.10-1_all.deb

# Install boto
# apt-get install -y python-boto

# Install ansible dependencies
sudo ansible-galaxy install -r $ANSIBLE_PROJECT/requirements.yml --force

# ssh-keygen -y -f $ANSIBLE_PROJECT/furfurpl.pem >> ~/.ssh/authorized_keys
# TODO: add fingerprint to known_hosts

# Run playbook
ansible-playbook -i $ANSIBLE_PROJECT/$INVENTORY -u $REMOTE_USER $ANSIBLE_PROJECT/$PLAYBOOK --connection=$CONNECTION -vvvv
