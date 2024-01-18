#add container name here
$containers = @(
'test02',
'test03',
'test04')
#------------------------

$status = docker ps -a | sls 'exit'

$servicepath = '/usr/sbin/sshd'


if ($status) {

foreach ($container in $containers) {
docker start $container
$OsType = docker exec $container cat /etc/os-release | sls '^ID='
#$OsType = ($OsType -replace 'ID=','')-replace '"',''

if ($OsType -match 'centos') {docker exec $container $servicepath}
if ($OsType -match 'ubuntu') {docker exec $container service ssh start}
 
 }
     
    }
