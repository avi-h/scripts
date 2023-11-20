###################################
# Prerequisites

# Get version of RHEL
source /etc/os-release
if [ $(bc<<<"$VERSION_ID < 8") = 1 ]
then majorver=7
elif [ $(bc<<<"$VERSION_ID < 9") = 1 ]
then majorver=8
else majorver=9
fi

# Register the Microsoft RedHat repository
curl -sSL -O https://packages.microsoft.com/config/rhel/$majorver/packages-microsoft-prod.rpm

# Register the Microsoft repository keys
sudo rpm -i packages-microsoft-prod.rpm

# Delete the repository keys after installing
rm packages-microsoft-prod.rpm

#------manual installation------------------------
curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.3.9/powershell-7.3.9-linux-x64.tar.gz
sudo mkdir -p /opt/microsoft/powershell/7
sudo tar zxvf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
sudo chmod +x /opt/microsoft/powershell/7/pwsh
sudo ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
#-----------end--------------------------------------


# RHEL 7.x uses yum and RHEL 8+ uses dnf
#if [ $(bc<<<"$majorver < 8") ]
#then
    # Update package index files
    #sudo yum update
    # Install PowerShell
    #sudo yum install powershell -y
#else
    # Update package index files
    #sudo dnf update
    # Install PowerShell
#   sudo dnf install powershell -y
#fi

