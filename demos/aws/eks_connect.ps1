$user = 'avi.h'
$domain = 'monalabs.io'
$pofile = 'mona'
$aws_role_arn = 'arn:aws:iam::785841601997:role/eks-admin'
$aws_region = 'us-east-1'

aws-google-auth -u "$user@$domain" -S 366612840080 -I C047wg4vw -R us-east-1 -d 43200 -p $profile

aws configure
#to view & add cluster to kubectl:

aws eks list-clusters --profile $profile --region $aws_region

$cluster = Read-Host "type cluster name"
Write-Host "adding $cluster to kubectl config" -ForegroundColor Yellow -BackgroundColor Black
aws eks update-kubeconfig --profile $profile --region $aws_region --name $cluster --role-arn $aws_role_arn



