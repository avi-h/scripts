'1. GPT
2. MBR'

$PartitionStyles = @('GPT','MBR')
$PartitionStyle = Read-Host 'Select format type (1-2)'

#Partition Style Menu
switch ($PartitionStyle)
{
    1 {"GPT was selected" }
    2 {"MBR was selected"}
    default {'No match, quitting';break}  
}

if ($PartitionStyle -lt 3 -and $PartitionStyle -gt 0 ) {

if ($PartitionStyle -match 1) {$PartitionStyle = $PartitionStyles[0]}
else {$PartitionStyle = $PartitionStyles[1]}
}

#FileSystem Menu
'1. NTFS
2. Fat32
3. exFAT'

$FileSystems = @('NTFS','Fat32','exFAT')
$FileSystem = Read-Host 'Select File system(1-3)'

switch ($FileSystem)
{
    1 {"NTFS was selected" }
    2 {"Fat32 was selected"}
    3 {"exFAT was selected"}
    default {'No match, quitting';break}  
}

if ($FileSystem -lt 4 -and $FileSystem -gt 0 ) {

if ($FileSystem -match 1) {$FileSystem = $FileSystems[0]}
if ($FileSystem -match 2) {$FileSystem = $FileSystems[1]}
if ($FileSystem -match 3) {$FileSystem = $FileSystems[2]}
}

#----------------------------------


#get usb drives
$list = Get-Disk | ? BusType -eq USB | select  Number,FriendlyName,
@{l='Size(GB)'
e={$_.size/1GB}},PartitionStyle | sort Number

#validation condition
$CountStart = $list.number[0]
$CountEnd = $list.Number.count
[regex]$match = "^[$CountStart-$countEnd]{1}$"

$list | Out-Host <#out-host Here 
tells this line to display the output before the read-Host #>

#select disk and validate
do {
if ($CountEnd -match 1) {
$Selected = Read-Host "Select USB Drive Number($countEnd)"
} else {
$Selected = Read-Host "Select USB Drive Number($CountStart-$countEnd)"
}

}until ($Selected -match $match)

$continue = Read-Host "Disk $Selected is selected, Formating?(y/n)"

#formatting
if ($continue -like 'y') {
Clear-Disk -Number $Selected -RemoveData -RemoveOEM -Confirm:$false
Set-Disk -Number $Selected -PartitionStyle $PartitionStyle

if ($PartitionStyle -notlike 'GPT') {
New-Partition -DiskNumber $Selected -UseMaximumSize -AssignDriveLetter -IsActive | 
Format-Volume -FileSystem $FileSystem | Out-Null
} else {
New-Partition -DiskNumber $Selected -UseMaximumSize -AssignDriveLetter | 
Format-Volume -FileSystem $FileSystem | Out-Null}

Write-Host "Disk $Selected is Formated" -ForegroundColor Yellow

$summery = Get-Disk -Number $Selected
$Letter = ($summery | Get-Partition).DriveLetter

$summery | ft  Number,FriendlyName,
@{l='Size(GB)'
e={$_.size/1GB}},PartitionStyle,@{l='FileSystem'
e={(Get-Volume -DriveLetter $Letter).FileSystem}} | sort Number

} else {
"Exit..."
break}
#--------End of disk format-------------