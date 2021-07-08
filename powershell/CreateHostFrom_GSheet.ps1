#API credentials
$spreadSheetID = "*****************************"
$SheetTabName = "Add-Host"
$scope = "https://www.googleapis.com/auth/spreadsheets.readonly"
$cert = "/etc/zabbix/g-sheet/Office.p12"
$pswd = (get-content "/etc/zabbix/g-sheet/Office.P12.paswd.txt")
$Client_Email = "readonly@office.iam.gserviceaccount.com"

#---import UMN-Google module------------------------------
$GsheetModule = (Get-Module -ListAvailable | ? name -Like 'UMN-Google').Name
if ($GsheetModule -like "UMN-Google") {} else {
Install-Module "UMN-Google" -Force}

#Get API Token
$Token = Get-GOAuthTokenService -iss $Client_Email -certPath $cert -certPswd $pswd -scope $scope

#Get g-sheet data
$SheetOutput = Get-GSheetData -accessToken $token -spreadSheetID $spreadSheetID -sheetName $SheetTabName -cell AllData

#------------end of G-sheet Data Request------------------------------


$ErrorActionPreference = 'Stop'

#import Zabbix PS module
#-------------------------
$checkZabbixModule = (Get-Module -ListAvailable | ? name -Like 'psbbix').Name
if ($checkZabbixModule -like "psbbix") {} else {
Install-Module "psbbix" -Force
}

#connect to Zabbix server
$ZabbixSRV = "zabbixsrv.office.taboola.com"
$session = (Get-ZabbixSession).URL

if ($session) {
Write-Host "connected to $session" -ForegroundColor Green -BackgroundColor Black}

else {
Write-Host "Connecting To:" $ZabbixSRV -ForegroundColor Yellow -BackgroundColor Black
$zabbixpwdfile = '/etc/zabbix/g-sheet/zabbixPwd.txt'
$zabbixuser = "zabbixapi"
$zabbixPwd = Get-Content $zabbixpwdfile | ConvertTo-SecureString
$Zabbixcreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $zabbixuser,$zabbixpwd
$connection = New-ZabbixSession $ZabbixSRV -PSCredential $Zabbixcreds -noSSL
}

#data to compare with Zabbix server
$ip = '127.0.0.1'
$DnsSuffix = '.office.com'

$siteList = @(
'ILDC','TLV','LON',
'BKK','NYC','LAC')

$HostTemplates = @(
'Template ICMP Ping',
'Template OS Linux',
'Template OS Windows',
'Template App Zabbix Agent')

$HostGroups = @(
'bangkok_servers',
'ildc_servers',
'london_servers',
'los_angeles_servers',
'new_york_servers',
'tel_aviv_servers'
)

# KickOff
foreach ($hostname in $SheetOutput) {

$DNS = ($hostname.AddHost.ToLower() + $DnsSuffix)

$check = (Get-ZabbixHost $hostname.AddHost.Tolower()).name

#check site 
if ($hostname.Site -like 'BKK'){$site = $HostGroups[0]}
if ($hostname.Site -like 'ILDC'){$site = $HostGroups[1]}
if ($hostname.Site -eq 'LON'){$site = $HostGroups[2]}
if ($hostname.Site -eq 'LAC'){$site = $HostGroups[3]}
if ($hostname.Site -eq 'NYC'){$site = $HostGroups[4]}
if ($hostname.Site -eq 'TLV'){$site = $HostGroups[5]}
#--------------

#Template Assignment
if($hostname.OS -like 'Windows'){$Template = $HostTemplates[0,2,3]}
if($hostname.OS -like 'Linux'){$Template = $HostTemplates[0,1,3]}
if($hostname.OS -like 'Device'){$Template = $HostTemplates[0]}
#---------------

if ($check -notlike $hostname.AddHost.ToLower()) {

$createHost = New-ZabbixHost -HostName $HostName.AddHost.ToLower() -GroupID ($site | 
% {Get-ZabbixGroup -GroupName $_}).GroupID -TemplateID ($Template|
% {Get-ZabbixTemplate -TemplateName $_}).TemplateID -status '0' -IP $ip -DNSName $DNS

$SwitchToDns = Get-ZabbixHost $hostname.AddHost.ToLower() | Get-ZabbixHostInterface | Set-ZabbixHostInterface -useIP 0 

#display created
$gethost = Get-ZabbixHost $hostname.AddHost.ToLower()
$ShowCreatedHost = Get-ZabbixHost $gethost.Name | select 'Name', 
@{l='groups';e={($_.Groups).Name}}, 
@{l='Templates';e={($_.parentTemplates).name -join ", "}},'HostID'
Write-Host "Created:" -ForegroundColor Green -BackgroundColor Black
$ShowCreatedHost | fl
#---------

} 

else {
Write-Host (
$hostname.Addhost) "was NOT created - already existed ?" -ForegroundColor Red -BackgroundColor Black

}

}
