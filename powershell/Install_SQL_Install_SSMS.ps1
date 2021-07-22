$SourcePath = "\\fileserver\software\Microsoft SQL Server\Install\"
$DestinationPath = "c:\installSQL"
$testpath = Test-Path "c:\installSQL"

if ($testpath -like $true) {

Remove-Item "C:\installSQL" -Recurse -Force -Verbose
}

Copy-Item $SourcePath -Destination $DestinationPath -Force -Recurse -Verbose


Write-Host "Installing SQL Server 2016...." -ForegroundColor Green
c:\installSQL\SQL_Svr_Std_2016_SP2_64Bit\setup.exe /CONFIGURATIONFILE=c:\installSQL\SQL_ConfigFile.ini 

Write-Host "Installing SQL Server Management Studio 18.2" -ForegroundColor Green
c:\InstallSQL\ManagementStudio_18.2.exe /install /norestart /passive
