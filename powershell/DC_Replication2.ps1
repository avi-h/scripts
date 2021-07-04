#to list all DC's in forest (numbered): 
do {
cls
$global:i=0
(Get-ADForest).Domains | foreach { Get-ADDomainController -Filter * -Server $_ } |sort Name|
Select @{l="Item";
E={$global:i++;$global:i}},

Name -OutVariable AllDCs | format-table -AutoSize

$Domain = 'dc=***,dc=***,dc=***'

Write-Host "Starting DC Replication..." -ForegroundColor Green

$SourceDcSelect = Read-Host "Select The Source DC (1-12)"
$SourceDcChoice = $AllDCs | where {$_.item -eq $SourceDcSelect}
Write-Host $SourceDcChoice.Name -NoNewline -ForegroundColor Magenta
Write-Host " Selected as Source" -ForegroundColor Green

$DestDcSelect = Read-Host "Select The Destination DC (1-12)"
$DestDcChoice = $AllDCs | where {$_.item -eq $DestDcSelect}
Write-Host $DestDcChoice.Name -NoNewline -ForegroundColor Magenta
Write-Host " Selected as Destination" -ForegroundColor Green

repadmin /replicate $DestDcChoice.Name $SourceDcChoice.Name $Domain

$rerun = Read-Host 'Running Again(y/n)?'
} while ($rerun -like 'y')

Write-Host 'Exit...' -ForegroundColor Yellow
Start-Sleep 01
cls