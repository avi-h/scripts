$Directory = 'C:\MyData\Pictures\'
$NewName = 'filename_0'
$items = Get-ChildItem -Path $Directory

$RenameAction = $items | 

% {$count = 0} {

$count++ ; 
Rename-Item -Path $_.FullName -NewName ($NewName + $count + $_.Extension) 

}


(Get-ChildItem $Directory).FullName


