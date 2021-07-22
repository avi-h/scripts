#Import-Module ActiveDirectory
$x = Get-Content C:\1.txt
foreach ($y in $x) 
{
try {
Get-ADUser -Identity $y | ft @{l='UserName'
e={$_.SamAccountName}}, @{l='FullName'
e={$_.name}} -AutoSize | 

Out-file c:\FoundUsers.txt -Append }

catch {Write-Host  $y  -ForegroundColor Red}}


<# option 2 : 

Import-Module ActiveDirectory
$x = Get-Content C:\1.txt
foreach ($y in $x) 
{
try {
Get-ADUser -Identity $y | select -ExpandProperty SamAccountName  |  

Out-file c:\FoundUsers.txt -Append }

catch {Write-Host  $y  -ForegroundColor Red}}

 #>





 









