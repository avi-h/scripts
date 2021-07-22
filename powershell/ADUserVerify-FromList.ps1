$users = Import-Csv C:\Data\111.csv

foreach ($user in $users.name) {


$aduser = Get-ADUser -Properties name -Filter {name -like $user}

if ($aduser.name -notlike $user) {

Write-Host $user -ForegroundColor Red


}


}



$users.name | % {Get-ADUser -Properties Department,Manager -Filter {name -like $_}} | 
select Department, @{l='Manager'

e={(Get-ADUser $_.manager).name}}
