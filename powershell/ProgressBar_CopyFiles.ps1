<#copy with progress bar
method 1
------------
#>
$srcPath = 'C:\mydata\pictures'
$DestPath = 'd:\data\'


$srcFiles = (Get-ChildItem $srcPath).FullName | Out-GridView -PassThru
$objShell = New-Object -ComObject "Shell.Application"
$objFolder = $objShell.NameSpace($DestPath)

foreach ($srcFile in $srcFiles) {

$objFolder.CopyHere($srcFile, 16) #16 means Always overwrite (code).

}

<#
method 2
---------------
Import-Module BitsTransfer -verbose
Start-BitsTransfer -Source $Source -Destination $Destination -Description "Backup" -DisplayName "Backup"


method 3
-------------
cmd /c copy /z src dest
#>