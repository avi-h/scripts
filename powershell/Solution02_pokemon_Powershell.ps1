
#URLs
$url = 'https://pokeapi.co/api/v2/'
$endpoint01 = 'pokemon-species'
$endpoint02 = 'evolution-chain'



#API Request
$buffer_size = (Invoke-RestMethod -Method Get -Uri ($url + $endpoint01)).count
$results_names = Invoke-RestMethod -Method Get -Uri ($url + $endpoint01 + "?limit=$buffer_size" )


#get all objects and add them to a Table
$poke_list = $results_names.results | 
select @{l='Number'
e={(($_.url)-replace($url01))-replace('/') }} , 

@{l='Name'
e={$_.name}}

#----end of table and data collection---------------------

$pokemon_name = (Read-Host "Enter Pokemon Name")

$poke_verify = $poke_list | ? {$_.name -like $pokemon_name}

if ($pokemon_name -like $poke_verify.Name) {

write-host $pokemon_name "was found and listed" -ForegroundColor Green -BackgroundColor Black

if ($poke_verify.Number -like 1) {
Write-Host $pokemon_name "is first in evolution chain" -ForegroundColor Yellow -BackgroundColor Black
}

$pre_chain = ([int]$poke_verify.Number - 1)

$pre_chain_poke = $poke_list | ? {$_.Number -like $pre_chain}

Write-Host $pokemon_name "evolves from" $pre_chain_poke.Name -ForegroundColor Magenta -BackgroundColor Black

} else {

Write-Warning "$pokemon_name doesnt exist, try another Pokemon"

}

Write-Host "NOTE:To view all listed pokemons plus their properties, run List_All_Powershell.ps1" -ForegroundColor Yellow -BackgroundColor Black