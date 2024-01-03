#Currency calc with error handling
do {

try {

$UserInputValid = $true
$FromCurrency = Read-Host "1.From which Currency ?"
[decimal]$Sum = Read-Host "2.How Much ?(Numbers)"
$ToCurrency =   Read-Host "3.To which Currency ?"

$uri = 'https://open.er-api.com/v6/latest/'

$response = Invoke-RestMethod ($uri + ($FromCurrency).ToString().ToUpper()) -Method 'GET'
$response_ToCurrency = Invoke-RestMethod ($uri + ($ToCurrency).ToString().ToUpper()) -Method 'GET' 

} catch {
Write-Host "User input Error" -ForegroundColor Red -BackgroundColor Black
$UserInputValid = $false
}

if ($UserInputValid -match $true) {

if (($response.result -match 'success') -and 
($response_ToCurrency.result -match 'success')) {

Write-Host $Sum $response.base_code =  ($response.rates.$ToCurrency * $Sum) $ToCurrency.ToString().ToUpper() -ForegroundColor Green -BackgroundColor Black

} else {Write-Host "Error in url request" -ForegroundColor Red -BackgroundColor Black}
  }

$re_run = Read-Host 'run again?(y/n)'

} while ($re_run -match 'y')