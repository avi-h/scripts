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
Write-Host
Write-Host "Connected:" $true.ToString().toupper()

Write-Host "SSID:" $SSIDName

Write-Host "Signal:" $Signal.ToUpper()

} else {

Write-Host "WiFi connection:" $false.ToString().ToUpper()
}

#-----------------------------------------

#verify internet connection
$testurl = 'google.com'
$intconnection = Test-NetConnection -ComputerName $testurl -WarningAction SilentlyContinue

if ($intconnection.PingSucceeded -like $true) {


Write-Host "Internet Connection:" $true.ToString().ToUpper()

} else {

Write-Host "internet connection:" $false.ToString().ToUpper()
}
Write-Host
Read-Host 'Press Enter to exit'
