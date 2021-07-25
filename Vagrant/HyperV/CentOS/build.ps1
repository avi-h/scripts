$Feature = 'Microsoft-Hyper-V-All'
$OS = 'Centos'
$Vagrantfile = 'https://raw.githubusercontent.com/avi-h/scripts/master/Vagrant/HyperV/CentOS/Vagrantfile'
$VagrantfileName = 'Vagrantfile'
$VMpath = "c:\HyperV\Vagrant\$OS"
$testpath = Test-Path $VMpath
$FQuery = Get-WindowsOptionalFeature -FeatureName $Feature -Online

if ($FQuery.State -like 'Enabled') {

if ($testpath -like 'False') {New-Item -Path $VMpath -ItemType Directory -Verbose}

Invoke-WebRequest -Uri $Vagrantfile -OutFile "$VMpath\$VagrantfileName" -Verbose

Set-Location $VMpath -Verbose
& vagrant up --color --timestamp


} else {

Write-Host "Hyper-V is not installed"

}