#gets and logs different network and usage statistics from the users computer

#setup date and working directory
$StartTime = Get-Date -UFormat "%d/%b/%Y, %R"
$CurrentUser = (Gwmi Win32_ComputerSystem).UserName.split("\")[1]
$LogFileName =  $CurrentUser+'-'+$env:COMPUTERNAME+
'-'+(get-date -UFormat %d-%b-%Y)+'.txt'


$path = "c:\Sauron"
$testpath = Test-Path $path
if ($testpath -like 'false') 
{New-Item $path -ItemType Directory}


<#----------------------
Actions and log output
----------------------#>

$diag = @(

'---------------------------------------------------'
'START OF DATA COLLECTION | START OF DATA COLLECTION'
'----------------------------------------------------'

#Get Date and Time
'Start Time: '+$StartTime

#Get the hostname of the computer
"HostName: "+ $env:ComputerName

#Get Current Logged on user
"Current User: " + $CurrentUser

"-------------------"
"User Sessions:"
'-------------------'

& quser

"=================================="

#OS & Computer details
"==================="
"Computer & OS info"
"==================="
"Brand: "+ (gwmi win32_computersystem).manufacturer
"Model: "+ (gwmi win32_computersystem).model
"Serial: "+ (gwmi win32_bios).serialnumber
"BiosVersion: "+ (gwmi win32_bios).version
"Family: "+ (gwmi win32_ComputerSystem).SystemFamily
"OS Name: "+ (gwmi win32_OperatingSystem).Caption
"OS Version: "+ (gwmi win32_OperatingSystem).Version
$UpTime = (Get-Date) - (gcim Win32_OperatingSystem).LastBootUpTime
'--------
Uptime:
--------'
"Days: "+$UpTime.Days
"Hours: "+$UpTime.Hours
"Minutes "+$UpTime.Minutes

write-host
'---
CPU
---'
$cpu = gwmi win32_processor
'Status: ' + $cpu.Status
'Cores: ' + $cpu.NumberOfCores
'LogicalProcessors: '+ $cpu.NumberOfLogicalProcessors
'ProcessorName: '+ $cpu.Name
'-----------------------------------------
Calculating CPU Percentage Average (10-13s)...'
$cpuPercentage = 1..13 | 
% {(gwmi win32_processor).LoadPercentage}
'Average (%): '+ ($cpuPercentage |
measure -Average).Average
write-host

'------
Memory
------'
systeminfo | Select-String Memory
write-host

"------------
PhysicalDisk
-------------"
Get-Disk | 

fl @{l='Type'
e={(Get-PhysicalDisk -DeviceNumber $_.Number).MediaType}},

@{l='TotalSize(GB)'
e={[math]::round($_.Size/1GB)}},
PartitionStyle

"--------------
DiskPartitions
---------------"
gwmi win32_logicaldisk | fl DeviceId, 
@{l="TotalSize(GB)"
e={[math]::Round($_.Size/1GB,2)}},
@{l="FreeSpace(GB)"
e={[math]::Round($_.FreeSpace/1GB,2)}},
VolumeName

'-------
Battery
-------'
$CheckBattery = Get-CimInstance BatteryStatus -Namespace root/wmi
if ($CheckBattery.Active -like 'True'){
$BatteryState = gwmi win32_battery
'Status:'+ $BatteryState.Status
'Active:'+ $CheckBattery.Active
'ChargeRemaining: '+ ($BatteryState.EstimatedChargeRemaining)+'%'
'PowerOnLine:'+ $CheckBattery.PowerOnline
}else {

"Battery wasn't found"
}

"=============
Certificates 
============="
"Computer: " 
Get-ChildItem Cert:\LocalMachine\my | 
? {$_.issuer -like "*Taboola*"} |
fl @{l='Name'
e={$_.DnsNameList}},

@{l='Issued'
e={$_.NotBefore}},

@{l='Expired'
e={$_.NotAfter}},

Issuer,Subject

write-host

'User:'
Get-ChildItem Cert:\CurrentUser\My | 
? {$_.issuer -like "*Taboola*"} |

fl @{l='Name'
e={$_.DnsNameList}},

@{l='Issued'
e={$_.NotBefore}},

@{l='Expired'
e={$_.NotAfter}},

Issuer,Subject


"============="
"Network info"
"============="

"----------------------------
Active Network & VPN Adapters
-----------------------------"
"Dns Suffix: "+ (((Get-DnsClientGlobalSetting).SuffixSearchList)-join',')

#ActiveAdapters
$adapters = Get-NetAdapter|?{$_.status -eq 'up'}

Get-DnsClientServerAddress -InterfaceAlias $adapters.name | 
? {$_.addressFamily -like 2 -and $_.address} | 

fl @{l='Interface'
e={$_.interfaceAlias}},

@{l='IpAddress'
e={(gip -InterfaceAlias $_.interfaceAlias).ipv4address}},

@{l='DefaultGateway'
e={(gip -InterfaceAlias $_.interfaceAlias).IPv4DefaultGateway.NextHop}},

@{l='DnsServers'
e={$_.Address}},

@{l='Description'
e={(Get-NetAdapter -Name $_.interfaceAlias).InterfaceDescription}}

#F5 Vpn info
$F5VPN =  gip | 
? {$_.InterfaceAlias -like "*access.taboola.com*"}

if ($F5VPN){

$F5VPN | select @{l='interface'
e={'F5 Vpn Adapter'}},

@{l='IpAddress'
e={$_.ipv4address}},DefaultGateway,

@{l='DnsServers'
e={$F5VPN.DNSServer.serveraddresses}},

@{l='Description'
e={$_.InterfaceAlias}}

}

#WiFi
'--------
WiFi info
---------'
netsh wlan show interfaces

#SpeedTest
'------------------
internet Speed-Test
-------------------'
$pubIpInfo = Invoke-RestMethod "http://ipinfo.io/json"
"publicIP: "+ $pubIpInfo.ip
"City: "+ $pubIpInfo.city
"Region: "+ $pubIpInfo.region
"Country: "+ $pubIpInfo.country

#Internet SpeedTest 
$OoklaFile = 'SpeedTest.exe'
$OoklaVerify = Test-Path "$path\$OoklaFile"

if ($OoklaVerify -like "True") {
& "$path\$OoklaFile" --accept-license}
else {"$path\$OoklaFile wasn't found, SpeedTest skipped"}

#Check for configured proxies
'------
Proxies
-------'
write-host
'Local Proxies'
'-------------------'
Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' | 
fl ProxyEnable,ProxyServer

write-host

'Google Chrome info'
'--------------------'
$chromepath = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome'
$extPath = "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Extensions"
$Verifychromepath = Test-Path $chromepath

if ($Verifychromepath -like 'True') {

'BrowserVersion: '+ (Get-ItemProperty $chromepath).Version

Get-ChildItem "$extPath\*\*\manifest.json" -ErrorAction SilentlyContinue | 
    
% {

Get-Content $_.FullName | 
ConvertFrom-Json | ? {$_.name -notlike "*__MSG*"} |

fl @{l='ExtensionName'
e={$_.Name}}, 

@{l='ExtensionVersion'
e={$_.Version}}


} 

}else {

'Chrome Browser wasnt found'

} 

'--------------------------------------'

'--------
HostFile
---------'
$env:SystemDirectory = [Environment]::SystemDirectory
$HostFilePath = "$env:SystemDirectory\drivers\etc\hosts"
"Path: $HostFilePath"
'-----'
"Content:"
'--------'
Get-Content $HostFilePath
'-------------------------------------------------------'

'==============================
Latency and Packet Loss Tests
==============================='
$externalHost = 'google.com'
$InternalHost = 'Jira.Taboola.com'
$GoogleDns = '8.8.8.8'
$F5VpnSite = 'Access.Taboola.com'
$ILDC = 'ildc01.office.taboola.com'

"Ping test to $externalHost"
"---------------------------"
ping $externalHost | 
Select-String Packets,Minimum,Approximate 

'-----------------------------------------'
"trace route test to $externalHost (3 hops)"
'-----------------------------------------'
tracert -d -h 3 $externalHost | 
Select-String 1,2,3

'----------------------------'
"Ping test to 2nd Hop...."
'-----------------------------'
$GoogleDnsTrace = Test-NetConnection $GoogleDns -TraceRoute -Hops 3
if ($GoogleDnsTrace.PingSucceeded -like 'True'){

$GoogleDnsTrace | fl RemoteAddress,

@{l='2nd Hop Address'
e={$GoogleDnsTrace.TraceRoute[1]}
}

"Ping to 2nd Hop Address..."
$GoogleDnsTrace.TraceRoute[1]

ping $GoogleDnsTrace.TraceRoute[1] | 
Select-String Packets,Minimum,
Approximate

}else {

"Ping Failed to" + $GoogleDnsTrace.TraceRoute[1]
"Reason: Connection Test to $GoogleDns is: " + 
$GoogleDnsTrace.PingSucceeded

}

'------------------------------------------------'

"Ping test to $F5VpnSite"
'--------------------------'
ping $F5VpnSite | 
Select-String Packets,Minimum,Approximate
'-----------------------------------------'

"Ping test to $InternalHost"
'------------------'
ping jira.taboola.com | 
Select-String Packets,Minimum,Approximate
'-----------------------------------------'
"Ping test to $ILDC"
'-------------------'
ping $ILDC | 
Select-String Packets,Minimum,Approximate

"TraceRoute to $InternalHost"
'---------------------------------'
$InternalHostTest =  Test-Connection jira.taboola.com -Count 2 -Quiet

if ($InternalHostTest -like 'True'){

tracert -d $InternalHost


} else {

"Trace FAILED to $InternalHost"

}

'-------------------------------'
"=============================================="
 Get-Date -UFormat "- END OF LOG - %d/%b/%Y, %R"
"=============================================="

)


$diag | Out-File "$path\$LogFileName" -Append


#upload file to azure storage share (smb)

$DriveLetter = 'S'
$UploadFolder = $CurrentUser+'-'+$env:COMPUTERNAME
$DriveVerify = Get-PSDrive -Name $DriveLetter -ea SilentlyContinue
$AzureServer = '***************************'
$AzureUser = "********************"
$Description = "Azure Storage"
$SecPwd = ConvertTo-SecureString "*****************************" -AsPlainText -Force

$AzureCreds = New-Object System.Management.Automation.PSCredential $AzureUser,$SecPwd

$ErrorActionPreference = 'Continue'

if ($DriveVerify) {& net use s: /delete}

$ConnectTestResult = Test-NetConnection -ComputerName $AzureServer -Port 445

if ($ConnectTestResult.TcpTestSucceeded -like "True") {


New-PSDrive -Name $DriveLetter -PSProvider FileSystem -Root "\\$AzureServer\sauron" -Persist -Description $Description -Credential $AzureCreds -Verbose -Confirm:$false

$UploadFolderVerify = Test-Path "S:\$UploadFolder"
if ($UploadFolderVerify -like 'False') {
New-Item -Name $UploadFolder -ItemType Directory -Path "S:\"

}

$AzureLogFileCheck = Test-Path "S:\$UploadFolder\$LogFileName"
$lastWriteTimeLocal = (Get-ItemProperty "$path\$LogFileName").LastWriteTime

if ($AzureLogFileCheck -like 'False') {

Copy-Item -Path "$path\$LogFileName" -Destination "S:\$UploadFolder" -Force -Verbose
} elseif ($AzureLogFileCheck -like 'True')

{

$lastWriteTimeAzure = Get-ItemProperty -Path "S:\$UploadFolder\$LogFileName"

if ($lastWriteTimeLocal -gt $lastWriteTimeAzure.LastWriteTime) 
{Copy-Item -Path "$path\$LogFileName" -Destination "S:\$UploadFolder\" -Force -Verbose}

}

& net use s: /delete

}

else 

{"Unable to reach the Azure storage account via port 445" | 
Out-File "$path\ERROR_$LogFileName"}



# Delete log Files older than 7 days (Local)
$WorkingPath = "C:\Sauron"
$extension = '.txt'
$Daysback = "-7"
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)

Get-ChildItem $WorkingPath -Recurse |
? { ($_.LastWriteTime -lt $DatetoDelete) -and ($_.Extension -like $extension)} |
Remove-Item -Verbose -Force

exit $LASTEXITCODE
#===============================================================================================