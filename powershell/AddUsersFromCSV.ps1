#UserList
$users = Import-Csv 'C:\temp\users.csv'

#generate random password (function)
function Generate-Password {
    param (
        [Parameter(Mandatory)]
        [int] $length,
        [int] $amountOfNonAlphanumeric = 1
    )
    Add-Type -AssemblyName 'System.Web'
    return [System.Web.Security.Membership]::GeneratePassword($length, $amountOfNonAlphanumeric)
}
 
#map the CSV file values to var
foreach ($user in $users) {

$displayname = $user.Name
$name = $user.Name
$fname = $user.GivenName
$lname = $user.Surname
$sam = $user.SamAccountName
$upn = $user.UserPrincipalName
$department = $user.Department
$ou = $user.OU
$pass = Generate-Password -length 8
$SecPass = ConvertTo-SecureString -String $pass -AsPlainText -Force

#create the users
New-ADUser -Name $name -DisplayName $displayname -GivenName $fname `
           -Surname $lname -SamAccountName $sam -UserPrincipalName $upn `
           -Department $department -Path $ou -Enabled $true -ChangePasswordAtLogon $true `
           -AccountPassword $SecPass

#verify if user existed in AD
$verifyUser = (Get-ADUser $user.SamAccountName).SamAccountName

#add and display the results in a table
$result = @{$verifyUser = $pass}
$result | select @{l='UserName';e={$_.keys}} ,
@{l='TempPass';e={$_.values}}

}