$FromCurrency = Read-Host "From Currency"
[decimal]$FromAmount = Read-Host 'Amount'
$ToRate = Read-Host "To Currency"

if ($FromAmount) {

$uri = 'https://open.er-api.com/v6/latest/' + ($FromCurrency).ToString().ToUpper()

$response = Invoke-RestMethod $uri -Method 'GET'


Write-Host $FromAmount $response.base_code =  ($response.rates.$ToRate * $FromAmount) $ToRate.ToString().ToUpper() -ForegroundColor Green -BackgroundColor Black

} else {

"No valid input"

}

