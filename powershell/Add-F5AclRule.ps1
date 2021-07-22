$ErrorActionPreference = 'stop'
$dstsubALL = '0.0.0.0/0'

$NewRulePort = '5433'
$NewRuleSub = 10.106.0.0/16
$NewRuleProtocols = '6'
$action = 'allow'  #or: reject
$L7_Servers = $null #"artifactory-build.com"
$L7_Schemes = $null #"http"

$User = 'admin'
$Devices = @("IL-access",'EU-ACCESS',
'APAC-ACCESS','NYC-ACCESS','LAC-ACCESS')


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
$global:i=0
$Devices | sort | 
Select @{l="Item";E={$global:i++;$global:i}},
{$_} -OutVariable ALLDevices |
ft -AutoSize

$DeviceSelect = Read-Host "Select a Device to connect(number)"
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




#ACL list & choice (numbered)

$global:i=0
(Get-AllAcl).items | sort name | 
Select @{l="Item";
E={$global:i++;$global:i}},
Name -OutVariable ALLACL | format-table -AutoSize


$ACLSelect = Read-Host "Select ACL (number)"
$ACLChoice = $ALLACL | where {$_.item -eq $ACLSelect}
Write-Host $ACLChoice.Name -NoNewline -ForegroundColor Yellow
Write-Host " is Selected" -ForegroundColor White

#-end of ACL list & choice----

$continue = Read-Host "Continue(y/n)?"

if ($continue -eq 'y') {




#restore existing rules

$rules = (Get-SingleAcl $ACLChoice.name).entries

Remove-Acl -name $ACLChoice.name
New-EmptyAcl -name $ACLChoice.name

foreach ($rule in $rules) {

if (($rule.action -ne 'reject') -and ($rule.dstsubnet -notlike $dstsubALL)){

Add-F5Acl -name $ACLChoice.name -dstStartPort $rule.dstStartPort -dstEndPort $rule.dstEndPort -dstSubnet $rule.dstSubnet -action $rule.action -Protocols $rule.protocol}


elseif ($rule.host -ne $null)

{Add-F5Acl -name $ACLChoice.name -dstStartPort $rule.dstStartPort -dstSubnet $rule.dstSubnet -action $rule.action -Protocols $rule.protocol -Layer7 -schemes $rule.scheme -hosts $rule.host}

  
}

#-----add new Rules------

if ($NewRuleSub) {
Add-F5Acl -name $ACLChoice.name -dstStartPort $NewRulePort  -dstSubnet $NewRuleSub -action $action -Protocols $NewRuleProtocols
}

if ($L7_Servers) {
Add-F5Acl -name $ACLChoice.name -dstStartPort 0 -dstSubnet 0 -action $action -Protocols 0 -Layer7 -schemes $L7_Schemes -hosts $L7_Servers
}

#--------------
  
#add Global deny rule
Add-F5Acl -name $ACLChoice.name -dstStartPort '0' -dstSubnet 0.0.0.0/0 -action 'reject' -Protocols 0

#results
(Get-SingleAcl -name $ACLChoice.name).entries | 
ft Action,DstSubnet,DstStartPort,DstEndPort,Protocol,Scheme,Host -AutoSize
Write-Host "ACL rules for:" $ACLChoice.name -ForegroundColor Yellow

}

else {break}
