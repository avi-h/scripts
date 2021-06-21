$poolState = (Get-WebAppPoolState -Name 'wsuspool').value
$poolState
$poolName = 'WsusPool'

if ($poolState -like 'stopped') {

#Send-MailMessage -From 'WSUS@taboola.com' -To 'avi.h@taboola.com' -Subject 'WsusPool State' -Body "the WSUS AppPool State is $poolState" -SmtpServer 'ildcsmtp.office.taboola.com'

Start-WebAppPool -Name $poolName 

Start-Sleep 03

$poolState = (Get-WebAppPoolState -Name 'wsuspool').value

#Send-MailMessage -From 'WSUS@Test.com' -To 'user@test.com' -Subject 'WsusPool State' -Body "the WSUS AppPool State is $poolState" -SmtpServer 'smtp.com'

$poolState

}


