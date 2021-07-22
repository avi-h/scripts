cls
$global:i=0
(Get-ADGroup -Filter {name -like "Radius*"}) |sort SamAccountName|
Select @{Name="Item";Expression={$global:i++;$global:i}},
@{Name='GroupName';Expression={$_.SamAccountName}} -OutVariable RadiusGroupList | 
format-table -AutoSize


$GRSelect = Read-Host 'Select The Radius group Number'
$GRChoice = ($RadiusGroupList | where {$_.Item -eq $GRSelect}).GroupName
Write-Host "$GRChoice Was Selected,Continue(y/n)?" -ForegroundColor Yellow -NoNewline
$continue = Read-Host


if ($Continue -like 'y') {

$CsvFile = "C:\Scripts\ADD_MAC-Users_FromCSV.csv"
$TestPath = Test-Path $CsvFile

if ($TestPath -like 'True') {

import-csv $CsvFile | foreach {

#removes special characters: 
$Username = (($_.UserName).tolower() -replace '[:\-\.]',"")
$Password = (($_.pass).tolower() -replace '[:\-\.]',"")
$FQDN = (($_.upn +"@office.com").tolower() -replace '[:\-]',"")
#---------------------------------------------------------------

New-ADUser -Path $_.OU -AllowReversiblePasswordEncryption $true -Enabled $true -Name $_.FullName -SamAccountName $Username -UserPrincipalName $FQDN -AccountPassword (ConvertTo-SecureString -AsPlainText $Password -Force) -PasswordNeverExpires $true -CannotChangePassword $true -DisplayName $_.FullName -PassThru
Set-ADAccountPassword -Identity $Username -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force)
Add-ADGroupMember $GRChoice -Members $Username

#get the security group token: 
$GrPath = (Get-ADGroup $GRChoice).DistinguishedName
$NewGr = [ADSI]"LDAP://$GrPath"
$NewGr.GetInfoEx(@("primaryGroupToken"), 0)
$NewGrToken = $NewGr.Get("primaryGroupToken")
#---------------------------------------------------

Set-ADUser $Username -Replace @{PrimaryGroupID=$NewGrToken}
Remove-ADGroupMember "Domain Users" -Members $Username -Confirm:$false
}  
 
}
 else {Write-Host "$CsvFilePath Was NOT Found" -ForegroundColor Red}

 }