do {
cls

$DBAModule = (Get-Module 'DbaTools').Name
if ($DBAModule -notlike 'DbaTools') {Install-Module "DbaTools" -Force -Verbose}

$backupfolder = 'C:\DBBackup'
$TestContent = (Get-ChildItem $backupfolder | measure).Count

if ($TestContent -ne 0) {

$global:i=0
Get-ChildItem $backupfolder | sort Name |
Select @{Name="Item";Expression={$global:i++;$global:i}},
@{Name='DBNAME';Expression={$_.BaseName}} -OutVariable DBLIST | format-table -AutoSize

$DBSelect = Read-Host "Select The DB Number To Restore"
$DBChoice =  $DBLIST | where {$DBSelect -eq $_.item }
$DB = $DBChoice.DBNAME

Write-Host "$DB was selected To Restore, Continue(y/n)?" -ForegroundColor Yellow -NoNewline
$Backup = Read-Host

if ($Backup -like 'y') {
$MDFPATH = "c:\DataBase\$DB\Data\" 
$LDFPATH = "c:\DataBase\$DB\Log\"


#$MDFNAME = $db + '.mdf'
#$LDFNAME = $db + '_log.ldf'



$backupFileName = $db + '.bak'
$instanceQA = ([System.Data.Sql.SqlDataSourceEnumerator]::Instance.GetDataSources()| 
where {$_.ServerName -eq $env:COMPUTERNAME}).InstanceName

$GetDB = Get-SqlDatabase -ServerInstance "$env:COMPUTERNAME\$InstanceQA" -Name $DB -ea SilentlyContinue
if ($GetDB.Name -eq $DB) {$GetDB.Drop()}


#$RelocateData = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($db , ($MDFPATH + $MDFNAME))
#$RelocateLog = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile(($db + '_log') , ($LDFPATH + $LDFNAME))
#Restore-SqlDatabase -ServerInstance "$env:COMPUTERNAME\$instanceQA" -Database $db -BackupFile ("$backupfolder\$backupFileName") -RelocateFile @($RelocateData,$RelocateLog) -verbose

Restore-DbaDatabase -SqlInstance "$env:COMPUTERNAME\$instanceQA" -DatabaseName $DB -Path "$backupfolder\$backupFileName" -DestinationDataDirectory $MDFPATH -DestinationLogDirectory $LDFPATH -Verbose

}


} else {
Write-Host "Backup file NOT found for $DB in $backupfolder" -ForegroundColor Yellow -BackgroundColor Red
}

$run = Read-Host "Running Again(y/n)?"

}
while ($run -like 'y')

cls