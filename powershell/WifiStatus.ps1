#displays Wifi connection name and signal strength
#tests the internet connection (true,false)
#---------------------------------------------------

$status = 'Connected'

#verify Wifi connection
$WifiState = gwmi win32_networkadapter | 
? {($_.netconnectionid -like "*wi-fi*") -and 
($_.name -notlike "*virtual*" ) -and
($_.netconnectionstatus -eq 2)} | 
select netconnectionid,
@{l='Status'
e={$status}}

#gettting and displaying data
if ($WifiState) {
$SSIDName = ((netsh wlan show interface) -match "ssid" -Replace '\s+ssid\s+:\s+','') | select -SkipLast 1
$Signal = (netsh wlan show interface) -match 'Signal' -Replace '\s+signal\s+:\s+','' 


#$str = [string]$signal -replace '%',''

#$number = [int]$str

#-----------------------------------------

Write-Host "Connected to $SSIDName WiFi network" -ForegroundColor Yellow -BackgroundColor Black

Write-Host "WiFi signal: $signal" -ForegroundColor Green -BackgroundColor Black

} else {

Write-Host "WiFi network is NOT connected"  -ForegroundColor Gray -BackgroundColor Black | Out-GridView
}

#-----------------------------------------

#verify internet connection
$testurl = 'google.com'
$intconnection = Test-NetConnection -ComputerName $testurl -InformationLevel Detailed

if ($intconnection.PingSucceeded -like $true) {


Write-Host "internet connection:"
Write-Host $true.ToString().ToUpper() -ForegroundColor Green

} else {

Write-Host "internet connection:"
Write-Host $false.ToString().ToUpper() -ForegroundColor Red -BackgroundColor Gray
}

Read-Host 'Press Enter to exit'
