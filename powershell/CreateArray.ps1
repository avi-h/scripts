$Array = @()
$Computers = "Computer1","Computer2","Computer3"

Foreach ($Computer in $Computers)
{

$Services = Get-WmiObject Win32_Service -ComputerName $Computer | Select name,state,startmode
    Foreach ($Service in $Services)
    {
    $Row = "" | Select Computer,Service,State,StartupMode
    $Row.Computer = $Computer
    $Row.Service = $Service.Name
    $Row.State = $Service.State
    $Row.StartupMode = $Service.StartMode
    $Array += $Row
    }
}

$Array