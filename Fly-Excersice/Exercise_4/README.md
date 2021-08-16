# Let's have some fun with Pokemon!

## Scripting excercise:

We need to prove you are good scripting basic stuff like API calls and CLI tools in order to get that proof We need you to create a very basic CLI tool with the following prerequesites:

Entering a Pokemon name the output will be the Pokemon name from the previous evolution. For instance if you enter "charmeleon" you get "charmeleon evolves from charmander". That should be the general behavior for our CLI tool but there are caveats you need to catch out:

1. If the entered Pokemon name is the first one in the evolution chain our CLI tool output should be: "Pokemon *'pokemon_name'* is the first one in the evolution chain"
2. If the entered Pokemon name is the top one in the evolution chain our CLI tool output should be:
"Pokemon *'pokemon_name'* is the top one in the evolution chain"
3. If the entered Pokemon name does not exist then our CLI tool output should be:
"Pokemon *'pokemon_name'* does not exist, try another Pokemon"

You have to use API endpoints from [pokeapi](https://pokeapi.co) in particular **/api/v2/pokemon-species** and **/api/v2/evolution-chain**. Another thing to have in mind is that Pokemon name is case sensitive and must be written in lower case.

We would like you use an scripting language such as Python, Go or Bash to do this exercise but it is up to you.

## Extra (poke)ball:

It would be nice to have a *help* and a way to list all Pokemon names using our CLI tool.
