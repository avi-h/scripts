#list items by numbers

(Gps).Name | 
% {$start=0 } { $start++ ; "$start.$_"}

#------------------------------------------

#for loop
for ($test = 1 ; $test -lt ((Get-ChildItem C:\data).count)+1  ; $test++)
{
[string]$test + '.' 
}

#----------------