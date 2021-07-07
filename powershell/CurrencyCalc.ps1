


$FromCurrancy = Read-Host "From"
[int]$FromAmount = Read-Host 'Amount'
$ToRate = Read-Host "To"

if ($FromAmount) {

$uri = 'https://open.er-api.com/v6/latest/' + ($FromCurrancy).ToUpper()

$response = Invoke-RestMethod $uri -Method 'GET'


Write-Host $FromAmount $response.base_code =  ($response.rates.$ToRate * $FromAmount) $ToRate.ToUpper() -ForegroundColor Green -BackgroundColor Black

} else {

"No valid input"


}





