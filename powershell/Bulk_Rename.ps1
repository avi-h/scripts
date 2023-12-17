$Directory = 'C:\MyData\Pictures'
$NewName = 'image_0'
$extention = '.jpg'


$items = Get-ChildItem -Path $Directory

$RenameAction = $items | 

% {$count = 0} {$count++ ; 
Rename-Item -Path $_.FullName -NewName ($NewName + $count + $extention)}


(Get-ChildItem $Directory).FullName


