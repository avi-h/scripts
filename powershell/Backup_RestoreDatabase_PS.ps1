$dbserverinstance1 = 'officedb1'
$dbserverinstance2 = 'officedb2'
$backupPath = "\\$env:COMPUTERNAME\c$\DBBackup\"
$db = Read-Host "DB name to backup"
$backupFileName = $db + '.bak'
$backupfilepath = Test-Path ($backupPath + $backupFileName)
$MDFPATH = "c:\DataBase\$DB\Data\" 
$LDFPATH = "c:\DataBase\$DB\Log\"
$MDFNAME = $db + '.mdf'
$LDFNAME = $db + '_log.ldf'
$TestMDFpath = Test-Path $MDFPATH
$TestLDFpath = Test-Path $LDFPATH

if ($TestMDFpath -like 'False') {New-Item $MDFPATH -ItemType 'Directory'}
if ($TestLDFpath -like 'False') {New-Item $LDFPATH -ItemType 'Directory'}

$backupfolder = Test-Path 'c:\dbbackup'

if ($backupfolder -like 'False') {New-Item 'c:\DBBackup' -ItemType 'Directory'}
if ($backupPath -like 'True') {Remove-Item $backupPath -Verbose -Force}


$checkprimary = (Get-SqlDatabase -ServerInstance $dbserverinstance1 -Name $db).isaccessible


if ($checkprimary -like 'True') {

Backup-SqlDatabase -ServerInstance $dbserverinstance1 -Database $db -CopyOnly -BackupFile ($backupPath + $backupFileName) -Verbose

} else

{
Backup-SqlDatabase -ServerInstance $dbserverinstance2 -Database $db -CopyOnly -BackupFile ($backupPath + $backupFileName) -Verbose
}

#------------------
#restore
#-----------------

$RestoreDB = Read-Host "Do you want to Restore The $db From This Backup (y/n)?"

if ($RestoreDB -eq 'y')
{

$instancename = (Get-ChildItem -Path SQLSERVER:\SQL\$env:COMPUTERNAME).InstanceName
$RelocateData = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($db , ($MDFPATH + $MDFNAME))
$RelocateLog = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile(($db + '_log') , ($LDFPATH + $LDFNAME))


Restore-SqlDatabase -ServerInstance "$env:COMPUTERNAME\$instancename" -Database $db -BackupFile ($backupPath + $backupFileName) -RelocateFile @($RelocateData,$RelocateLog) -verbose
}
