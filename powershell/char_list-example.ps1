$alph=@()
65..90|

foreach {
$alph+=[char]$_ + '.'
}

$alph
