$FromCurrency = Read-Host "From Currency"
try {
[decimal]$Sum = Read-Host 'Sum(Digits Only)'
} catch {'Wrong input format'}
$ToCurrency = Read-Host "To Currency"

$uri = 'https://open.er-api.com/v6/latest/'
$response = Invoke-RestMethod ($uri + ($FromCurrency).ToString().ToUpper()) -Method 'GET'
$response_ToCurrency = Invoke-RestMethod ($uri + ($ToCurrency).ToString().ToUpper()) -Method 'GET'

if ($response.result -match 'Success' -and $response_ToCurrency.result -match 'Success') {

Write-Host $Sum $response.base_code =  ($response.rates.$ToCurrency * $Sum) $ToCurrency.ToString().ToUpper() -ForegroundColor Green -BackgroundColor Black

} else {
Write-Host 'FromCurrency_Code:' $response.result -ForegroundColor Red -BackgroundColor Black
Write-Host 'ToCurrency_Code:' $response_ToCurrency.result -ForegroundColor Red -BackgroundColor Black

}
