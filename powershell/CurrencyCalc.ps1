do {
Clear-Host
Write-Host "========================================="
Write-Host "wellcome to currency exchange calculator." -ForegroundColor Yellow -BackgroundColor Black
Write-Host "========================================="
Write-Host "to get your currency rate, answer the following 3 questions" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "======================================================================="
Write-Host "NOTE: Make sure you type CORRECTLY the currency international code type.
Case-sensitive is not mandatory.

Example: for US Dollar type: USD, for Euros type: EUR, for UK type: GBP ." -ForegroundColor Yellow -BackgroundColor DarkGray
Write-Host "======================================================================="
Write-Host "currency code list can be found here:
=========================================
https://www.iban.com/currency-codes
========================================="

try {

$UserInputValid = $true
$FromCurrency = Read-Host "1. From which Currency ?"
$ToCurrency =   Read-Host "2. To what Currency ?"
[decimal]$Sum = Read-Host "3. How Much ?(Numbers)"


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

} else {Write-Host "Error in url request(User input)" -ForegroundColor Red -BackgroundColor Black}
  }

$re_run = Read-Host 'run again?(y/n)'

} while ($re_run -match 'y')
