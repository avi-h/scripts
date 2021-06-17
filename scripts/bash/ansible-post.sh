#!/bin/bash -e

#Clean yum cache
yum -y clean all

# Shrink / rm logs
logrotate -f /etc/logrotate.conf
rm -f /var/log/*-???????? /var/log/*.gz
rm -f /var/log/dmesg.old
rm -rf /var/log/anaconda
cat /dev/null > /var/log/audit/audit.log
cat /dev/null > /var/log/wtmp
cat /dev/null > /var/log/lastlog
cat /dev/null > /var/log/grubby

# Clean up user history
rm -f ~/.bash_history

# Clean Home Directory - Fixes Packer Bug of faulty dir
rm -Rf /home/*