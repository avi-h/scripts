$PartitionStyle = 'GPT' # 'GPT' or 'MBR'
$FileSystem = 'ntfs' #ntfs,fat32,exFAT,Fat,ReFS
$isoPath = 'C:\data\ISO\WinPE_x64_PS.iso'

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

$continue = Read-Host "Disk $Selected is selected,Formating?(y/n)"

#formatting
if ($continue -like 'y') {
Clear-Disk -Number $Selected -RemoveData -RemoveOEM -Confirm:$false
Set-Disk -Number $Selected -PartitionStyle $PartitionStyle

if ($PartitionStyle -like 'MBR') {
New-Partition -DiskNumber $Selected -UseMaximumSize -IsActive:$true -AssignDriveLetter | 
Format-Volume -FileSystem $FileSystem } else {

New-Partition -DiskNumber $Selected -UseMaximumSize -AssignDriveLetter | 
Format-Volume -FileSystem $FileSystem }

Write-Host "Disk $Selected is Formated" -ForegroundColor Yellow

Get-Disk -Number $Selected | ? BusType -eq USB | ft  Number,FriendlyName,
@{l='Size(GB)'
e={$_.size/1GB}},PartitionStyle | sort Number

} else {
"Exit..."
break}
#--------End of disk format-------------


#Copy (like burn) the Windows iso file to the formated USB drive
#---------------------------------------------------------------
$Results = Get-Partition -DiskNumber $Selected
$Volumes = (Get-Volume).Where({$_.DriveLetter}).DriveLetter
Mount-DiskImage -ImagePath $isoPath
$ISO = (Compare-Object -ReferenceObject $Volumes -DifferenceObject (Get-Volume).Where({$_.DriveLetter}).DriveLetter).InputObject

#copy process
Set-Location -Path "$($ISO):\boot"
bootsect.exe /nt60 "$($Results.DriveLetter):"
Copy-Item -Path "$($ISO):\*" -Destination "$($Results.DriveLetter):" -Recurse -Verbose

#dismount iso file
Dismount-DiskImage -ImagePath $isoPath -Verbose -Confirm:$false
