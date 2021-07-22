$User = Read-Host "Type The UserName" 
$password = "*********"
$mail_alias = 'office@mail.com'

Write-Host "Selected User:" -ForegroundColor Magenta
Write-Host ((Get-ADUser $User).Name)'('((Get-ADUser $User).SamAccountName)')'  -ForegroundColor Yellow

$run = Read-Host "Continue(y/n)?"

if ($run -like 'y') {

##reset password##
Set-ADAccountPassword -Identity $User -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force) -Verbose -Confirm:$false

##group membership removal##
$GroupMembership = (Get-ADPrincipalGroupMembership $User) | 
where {(($_.name -notlike "Brain-Users") -and 
($_.name -notlike "Jira-Users") -and 
($_.name -notlike "Domain Users") -and
($_.name -notlike "IL-Office") -and
($_.name -notlike "Atlassian External")
)}

if ($GroupMembership -ne $null) {
$GroupMembership.SamAccountName | 
foreach {Remove-ADGroupMember $_ -Members $User -Confirm:$false -Verbose}}
else {
Write-Host "GroupMembership Veriable is NULL" -ForegroundColor Red
Write-Host "No Groups to remove the User from" -ForegroundColor Red
}

##change EmailAddress to .DEP##
$CurrentMail = ((Get-ADUser $user -Properties mail).mail)
$UserFromMail = $CurrentMail.Replace($mail_alias,"")
$Email_DEP = $UserFromMail + ".DEP" + $mail_alias

Set-ADUser $User -EmailAddress $Email_DEP
#--------------------------------------------

Get-ADUser $User -Properties Mail,MemberOf,ProxyAddresses | 
select Name,SamAccountName,Mail,ProxyAddresses, @{l='Groups'
e={(Get-ADPrincipalGroupMembership $User).name}}

}