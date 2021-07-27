$Feature = 'Microsoft-Hyper-V-All'
$OS = 'centos'
$Vagrantfile = 'https://raw.githubusercontent.com/avi-h/scripts/master/Vagrant/HyperV/CentOS/Vagrantfile'
$VagrantfileName = 'Vagrantfile'
$VMpath = "c:\HyperV\Vagrant\$OS"
$testpath = Test-Path $VMpath
$FQuery = Get-WindowsOptionalFeature -FeatureName $Feature -Online
$boxname = 'centos7.box'
$boxPath = "$VMpath\$boxname"
$boxImage_Verify = Test-Path $boxPath
$Provider = 'hyperv'


if ($FQuery.State -like 'Enabled') {

if ($testpath -like 'False') {New-Item -Path $VMpath -ItemType Directory -Verbose}


Set-Location $VMpath

$VerifyBox = vagrant box list

if ($VerifyBox) {


if ($VerifyBox.Remove(7) -like $boxname.Remove(7)) {

Write-Host $boxname.remove(7) "machine found..." -ForegroundColor Yellow
Set-Location $VMpath

Write-Host "Running vagrant up command..." -ForegroundColor Yellow
Remove-Item "$VMpath\$VagrantfileName" -Force -ErrorAction SilentlyContinue
& vagrant init $boxname.Remove(7)
Write-Host "Downloading Vagrant file to: " $VMpath -ForegroundColor Yellow
Invoke-WebRequest -Uri $Vagrantfile -OutFile "$VagrantfileName" -Verbose
& vagrant up --color --timestamp --provider $Provider

} 

elseif ( ($boxImage_Verify -like 'True')  -and
($VerifyBox.Remove(7) -notlike $boxname.Remove(7) )) {

Write-Host $boxname.Remove(7) "wasnt found, Building..." -ForegroundColor Yellow
Set-Location $VMpath
Remove-Item "$VMpath\$VagrantfileName" -Force -ErrorAction SilentlyContinue

& vagrant box add $boxname.Remove(7)  $boxname
& vagrant init $boxname.Remove(7) 
Invoke-WebRequest -Uri $Vagrantfile -OutFile "$VMpath\$VagrantfileName" -Verbose
& vagrant up --color --timestamp --provider $Provider

} 

elseif ($boxImage_Verify -like 'False') {

Write-Host "image file" $boxPath "wasnt found." -ForegroundColor Yellow 
Write-Host $boxname.Remove(7) "Box wasnt created." -ForegroundColor Yellow
break }

}

} else {

Write-Host "Hyper-V is not installed"


}