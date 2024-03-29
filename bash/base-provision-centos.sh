#/bin/bash
yum update -y
yum install bash-completion -y
yum install bash-completion-extras -y
yum install net-tools -y
yum install vim -y
yum install tcpdump -y
yum install docker -y
yum install gnupg2 -y
yum install wget -y
yum install bind-utils mtr -y
yum install traceroute nslookup -y
systemctl enable docker
systemctl start docker
systemctl stop firewalld
systemctl disable firewalld
#hostnamectl set-hostname centos7
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod 777 /usr/local/bin/docker-compose
#curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
yum update -y
#sudo yum install -y powershell
#pwsh --version
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config
shutdown -r now
