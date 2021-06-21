#import AWS S3 module
$S3Module = (Get-Module -ListAvailable | ? name -Like 'AWS.Tools.S3').Name
if ($S3Module -like "AWS.Tools.S3") {} else {
Install-Module "AWS.Tools.S3" -Force}

#Create Aws Connection
$AwsIDKey = "*****************"
$AWSSecretFile = Get-Content 'D:\Scripts\AWS\SecretKey.txt' | ConvertTo-SecureString
$Creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AwsIDKey,$AWSSecretFile
$AWScred = Set-AWSCredential -AccessKey $creds.UserName -SecretKey $Creds.GetNetworkCredential().Password

#Ex: get bucket content in some folder
$Bucket = 'officeit'
$folder = 'zabbix'

Get-S3Object -BucketName $Bucket -Prefix $folder | 
select Key,LastModified, @{l='Size(MB)'
e={$_.size / 1MB}} | fl

#More commands you may check:
#----------------------------
#write-s3Object
#Copy-S3object
#Remove-S3Object