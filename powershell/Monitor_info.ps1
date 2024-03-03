$Monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi

function Decode {
    If ($args[0] -is [System.Array]) {
        [System.Text.Encoding]::ASCII.GetString($args[0])
    }
    Else {
        "Not Found"
    }
}


ForEach ($Monitor in $Monitors) {  
    $Manufacturer = Decode $Monitor.ManufacturerName -notmatch 0
    $Brand = Decode $Monitor.UserFriendlyName -notmatch 0
    $Serial = Decode $Monitor.SerialNumberID -notmatch 0
    $ComputerName = $Monitor.PSComputerName
    $release = $Monitor.YearOfManufacture
    Write-Host
    "ComputerName: $ComputerName
     Manufacturer: $Manufacturer
     Model: $Brand
     Serial: $Serial
     ReleaseYear: $release"

}

