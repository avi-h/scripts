#displays Wifi connection name and signal strength
$status = 'Connected'

$WifiState = gwmi win32_networkadapter | 
? {($_.netconnectionid -like "*wi-fi*") -and 
($_.name -notlike "*virtual*" ) -and
($_.netconnectionstatus -eq 2)} | 
select netconnectionid,
@{l='Status'
e={$status}}

if ($WifiState) {
$SSIDName = ((netsh wlan show interface) -match "ssid" -Replace ‘\s+ssid\s+:\s+’,'') | select -SkipLast 1
$Signal = (netsh wlan show interface) -match ‘Signal’ -Replace ‘\s+signal\s+:\s+’,'' 


#$str = [string]$signal -replace '%',''

#$number = [int]$str

#-----------------------------------------------------

Write-Host "Connected to $SSIDName WiFi network" -ForegroundColor Yellow -BackgroundColor Black

Write-Host "WiFi signal: $signal" -ForegroundColor Green -BackgroundColor Black

} else {

Write-Host "WiFi network is NOT connected"  -ForegroundColor Gray -BackgroundColor Black | Out-GridView
}

Read-Host 'Press Enter to exit'



