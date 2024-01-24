#/bin/bash
#yum repolist -y
#yum update -y
#yum install bash-completion -y
#yum install bash-completion-extras -y
#yum install net-tools -y
#yum install vim -y
#yum install tcpdump -y
#yum install gnupg2 -y
#yum install wget -y
#yum install bind-utils mtr telnet -y
#yum install traceroute nslookup ethtool -y
#yum install openssh-server -y
#yum update -y
#yum upgrade -y
cd /tmp
curl 'http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/centos-gpg-keys-8-3.el8.noarch.rpm' --output gpgkeys.rpm
rpm -i gpgkeys.rpm
yum --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos -y
rm -rvf /tmp/gpgkeys.rpm
yum update -y
yum install https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/powershell-7.4.1-1.rh.x86_64.rpm -y
yum upgrade -y