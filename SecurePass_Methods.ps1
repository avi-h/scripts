#store & secured password - example
$SecureUserInput = Read-Host 'enter password' -AsSecureString
$EncryptedInput = ConvertFrom-SecureString -SecureString $SecureUserInput
$SecureString = ConvertTo-SecureString -String $EncryptedInput

#===============================================================================
#other_way - PS vault

Install-Module -Name Microsoft.PowerShell.SecretManagement -Repository PSGallery -Scope AllUsers

Install-Module -Name Microsoft.PowerShell.SecretStore -Repository PSGallery -Scope AllUsers
#create a vault
Register-SecretVault -Name HolaVault -ModuleName microsoft.powershell.SecretStore -DefaultVault

#create a secret
Set-Secret -Name MyToken -Secret 'Pass@word!'

<# if its your first secret to be saved in the vault,
PowerShell will prompt you for a password #>
