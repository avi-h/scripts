#Script Description


do {
#URLs
$url01 = 'https://pokeapi.co/api/v2/pokemon-species'
$url02 = 'https://pokeapi.co/api/v2/pokemon/'
#API Request
$buffer_size = (Invoke-RestMethod -Method Get -Uri $url01).count
$results01 = Invoke-RestMethod -Method Get -Uri ($url01 + "?limit=$buffer_size" )


#get all objects and add them to a Table
$poke_list = $results01.results | 
select @{l='Number'
e={(($_.url)-replace($url01))-replace('/') }} , 

@{l='Name'
e={$_.name}}

#----end of table and data collection---------------------


$count = $poke_list.Count

#output results
$poke_list | Out-String

try {


[int]$select = Read-Host "Select Pokemon Number(1-$count)"

#data input validation & error handaling
if ($select -and $select -le $count) {
$selection = $poke_list | ? {$_.number -like $select
}

Write-Host $selection.Name "is Selected" -ForegroundColor Green -BackgroundColor Black

if ($selection.Number -eq 1) {
Write-Host $selection.Name "is the first name in the Evolution-Chain!" -ForegroundColor Yellow -BackgroundColor Black

}

$results02 = Invoke-RestMethod -Method Get -Uri ($url02 + ($selection.Name).ToLower()+$buffering)
$results02 | fl Name,ID,Weight,Height

 } 

 else {Write-Warning "your choice is not in range"}
    
 } catch {
                
        
Write-Host "No Data found. Try another" -ForegroundColor Red -BackgroundColor black


}

$run = Read-Host "Run Again ?(y/n)"

    } while ($run -like 'y')

#script will run in a loop based on user's choice