#displays Wifi connection name and signal strength
#tests the internet connection (true,false)
#output results in hash table
#---------------------------------------------------

$result = @(


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
$result01 = @{

"WiFi connection" = $true.ToString().toupper()

"SSID" = $SSIDName

"Signal" = $Signal.ToUpper() }

} else {

$result01 = @{

"WiFi connection" = $false.ToString().ToUpper()
} 
 
 } 
 
#-----------------------------------------

#verify internet connection
$testurl = 'google.com'
$intconnection = Test-NetConnection -ComputerName $testurl -WarningAction SilentlyContinue

if ($intconnection.PingSucceeded -like $true) {

$result02 = @{
"Internet Connection" = $true.ToString().ToUpper()
}

} else {

$result02 = @{
"internet connection" = $false.ToString().ToUpper()
}
  }
   
  ) 

$output = @($result01

$result02)

$output

Write-Host
Read-Host "Press Enter to exit"