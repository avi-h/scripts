$PartitionStyle = 'GPT'
$FileSystem = 'Fat32' #ntfs,Fat32,exFat
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
New-Partition -DiskNumber $Selected -UseMaximumSize -AssignDriveLetter | 
Format-Volume -FileSystem $FileSystem

Write-Host "Disk $Selected is Formated" -ForegroundColor Yellow

Get-Disk -Number $Selected | ? BusType -eq USB | ft  Number,FriendlyName,
@{l='Size(GB)'
e={$_.size/1GB}},PartitionStyle | sort Number

} else {
"Exit..."
break}
#--------End of disk format-------------
