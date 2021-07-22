$ErrorActionPreference = 'stop'
$NewRulePort = '443'
$NewRuleSub = "10.154.2.229/32","10.154.0.70/32","10.154.1.125/32"
$dstsubALL = '0.0.0.0/0'
$NewRuleProtocols = '6'
$L7_Servers = "watercooler.com"
$L7_Schemes = "http"
$action = 'allow'   #or: reject

$Path = 'C:\Data\f5SSL-GRP.txt'
$SSLGroups = 'TEST'#Get-Content $Path
Write-Host "ACL list from" $Path':' -BackgroundColor Black -ForegroundColor Yellow
$SSLGroups


#check F5-APM module
$module1 = "F5-APM"
$module2 = "F5-LTM"
$CheckModule1 = (Get-Module -ListAvailable | ? name -Like $module1).Name
$CheckModule2 = (Get-Module -ListAvailable | ? name -Like $module2).Name
if ($CheckModule1 -notlike $module1) {Install-Module $module1 -Force -Verbose}
else {Write-Host $module1 'module is installed' -ForegroundColor Yellow}
if ($CheckModule2 -notlike $module2) {Install-Module $module2 -Force -Verbose}
else {Write-Host $module2 'module is installed' -ForegroundColor Yellow}


#Device list & Select
Write-Host "F5 Devices:" -ForegroundColor Yellow -BackgroundColor Black
$global:i=0
$Devices | sort | 
Select @{l="Item";E={$global:i++;$global:i}},
{$_} -OutVariable ALLDevices |
ft -AutoSize

$DeviceSelect = Read-Host "Select a Device To Connect(number)"
$DeviceChoice = $ALLDevices | where {$_.item -eq $DeviceSelect}
Write-Host $DeviceChoice.'$_' -NoNewline -ForegroundColor Yellow
Write-Host " is Selected" -ForegroundColor White

$DeviceConfirm = Read-Host "Continue(y/n)?"

if ($DeviceConfirm -eq 'y') {

if ($F5Session.Name -like $DeviceChoice.'$_')
{Write-Host "already connected to" $F5Session.name -ForegroundColor Yellow}

else {Write-Host "not connected to" $DeviceChoice.'$_' -ForegroundColor Red
Connect-F5 -ip $DeviceChoice.'$_' -creds $user} 

} elseif ($DeviceConfirm -ne 'y') {break}


#restore existing rules

foreach ($SSLGroup in $SSLGroups) {

$ACLVerify = Get-SingleAcl $SSLGroup

if ($ACLVerify.name -eq $SSLGroup) {

$rules = (Get-SingleAcl $sslgroup).entries
Remove-Acl -name $sslgroup -Verbose
New-EmptyAcl -name $sslgroup -Verbose

foreach ($rule in $rules) {


if (($rule.action -ne 'reject') -and ($rule.dstsubnet -notlike $dstsubALL)) {

Add-F5Acl -name $sslgroup -dstStartPort $rule.dstStartPort -dstEndPort $rule.dstEndPort -dstSubnet $rule.dstSubnet -action $rule.action -Protocols $rule.protocol}


elseif  ($rule.host -ne $null)

{Add-F5Acl -name $sslgroup -dstStartPort $rule.dstStartPort -dstSubnet $rule.dstSubnet -action $rule.action -Protocols $rule.protocol -Layer7 -schemes $rule.scheme -hosts $rule.host

}

     
    } 
    

#add new Rules
Add-F5Acl -name $sslgroup -dstStartPort $NewRulePort  -dstSubnet $NewRuleSub -action $action -Protocols $NewRuleProtocols -Verbose


if ($L7_Servers -and $L7_Schemes) {
Add-F5Acl -name $sslgroup -dstStartPort 0 -dstSubnet 0 -action $action -Protocols 0 -Layer7 -schemes $L7_Schemes -hosts $L7_Servers -Verbose


}

  
#add Global deny rule
Add-F5Acl -name $sslgroup -dstStartPort '0' -dstSubnet 0.0.0.0/0 -action 'reject' -Protocols 0 -Verbose

} 

else {Write-Host $SSLGroup "is not existed" -ForegroundColor Red -BackgroundColor Black;break}

}



#results
foreach ($SSLGroup in $SSLGroups) {
(Get-SingleAcl -name $sslgroup).entries | 
ft Action,DstSubnet,DstStartPort,DstEndPort,Protocol,Scheme,Host -AutoSize
Write-Host "ACL rules for:" $sslgroup -ForegroundColor Yellow -BackgroundColor Black}

