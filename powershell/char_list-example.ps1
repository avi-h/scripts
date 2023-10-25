$A_to_Z = @()
65..90 |
foreach {
$A_to_Z+=[char]$_ + '.'
}
$A_to_Z
