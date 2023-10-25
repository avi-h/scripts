#example to display A-Z letters
#change the numbers range to display other elements

$A_to_Z = @()

65..90 |

foreach {
$A_to_Z+=[char]$_ + '.'
}

$A_to_Z
