#user can type only 1 digit, from 0 to 5
$count = 5
[regex]$match = "^[0-$count]{1}$" 


do {

$string = Read-Host "Enter number (0-$count)"

}until ($string -match $match)

$string
