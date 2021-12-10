$computers = 'localhost'
$user = Read-Host 'username'
$pass = Read-Host 'password'
foreach($computer in $computers) {   
    $localUser = [ADSI]  "WinNT://$computerName/$user"  
    $localUser.SetPassword($Pass)  
} 