#API credentials
$spreadSheetID = "******************"
$SheetTabName = "CRT"
$scope = "https://www.googleapis.com/auth/spreadsheets.readonly"
$cert = "G:\My Drive\Scripts\Zabbix\Centos\g-sheet\GoogleAPI_OfficeIT-ReadOnly.p12"
$pswd = (get-content "G:\My Drive\Scripts\Zabbix\Centos\g-sheet\GoogleAPI_OfficeIT-ReadOnly.P12.paswd.txt")
$Client_Email = "officeit-readonly@gserviceaccount.com"
#--------------------

#check g-sheet module 
$GsheetModule = (Get-Module -ListAvailable | ? name -Like 'UMN-Google').Name
if ($GsheetModule -like "UMN-Google") {} else {
Install-Module "UMN-Google" -Force}

#get token access for
$Token = Get-GOAuthTokenService -iss $Client_Email -certPath $cert -certPswd $pswd -scope $scope -Verbose

#get g-sheet data
$sheet = Get-GSheetData -accessToken $Token -spreadSheetID $spreadSheetID -sheetName $SheetTabName -cell AllData
$sheet