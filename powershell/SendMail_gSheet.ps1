#API credentials
$spreadSheetID = '****************************'
$SheetTabName01 = 'External'
$scope = "https://www.googleapis.com/auth/spreadsheets.readonly"
$cert = "G:\Office IT\Zabbix\Centos\g-sheet\GoogleAPI_OfficeIT-ReadOnly.p12"
$pswd = "notasecret"
$Client_Email = "officeit-readonly@office.com"

#---import UMN-Google module------------------------------
$GsheetModule = (Get-Module -ListAvailable | ? name -Like 'UMN-Google').Name
if ($GsheetModule -like "UMN-Google") {} else {
Install-Module "UMN-Google" -Force}

##Get API Token
$Token = Get-GOAuthTokenService -iss $Client_Email -certPath $cert -certPswd $pswd -scope $scope

#Get g-sheet data
$SheetOutput = Get-GSheetData -accessToken $token -spreadSheetID $spreadSheetID -sheetName $SheetTabName -cell AllData


#-------end of API Request----------


$smtp = 'smtp.office.com'
$port = 25
$from = "mail@office.com"
$F5attachment = "G:\My Drive\Docs\IT-F5VPNClient-HowToConnect.pdf"


$SheetOutput |

% {Send-MailMessage -From $from -To $_.ExternalEMail -Cc 'avi.h@Taboola.com' -Subject "Taboola's google Auth." -SmtpServer $smtp -Port $port -Body (

"
Hi $($_.FullName),
To authenticate with your google account,
Use these following credentials:

Google Account: $($_.mail)
Password: $($_.Adpass)
Domain UserName (might be necessary in future): $($_.UserName)

Backstage APP:
-------------
Website: $($_.BsURL)
User: $($_.mail)
Password For first Login: *****


IMPORTANT!!!:  Please Activate the Google 2 step verification option !!!
-----------------------------------------------------------------------

Here is the steps how to activate that option:

1.	Go to your Google Account.
2.	On the left navigation panel, click Security.
3.	On the Signing in to Google panel, click 2-Step Verification.
4.	Click Get started.
5.	Follow the steps on the screen.

LMK if There are any issues about.


Corporate IT.


"
) -Verbose

}