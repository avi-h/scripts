import random
def welcome(name):
    return "=====================================" \
           "\nhello " + name.upper() + ", welcome to World Of Games.\n"\
           "here are some cool games to play.\n" \
           "====================================="

username = input('please enter your name:')
title = welcome(username)
print(title)

def load_game():
    games = list(('1.Memory Game','2.Guess Game','3.Currency Roulette'))
    return games

for game in load_game():
    print(game)
game_select = input('please select a game(1-3):')
games = load_game()

if game_select.isdigit():
    game_select = int(game_select)
    if game_select == 1:
        print(games[0].replace('1.',''),'is selected.')
    if game_select == 2:
        print(games[1].replace('2.', ''),'is selected.')
    if game_select == 3:
        print(games[2].replace('3.', ''),'is selected.')
    elif game_select == 0:
        print('not accepted value')
    if game_select <=3:
        difficulty = list((1,2,3,4,5))
        level = input('select difficulty level(1-5):')
        if level.isdigit():
            level = int(level)
            if level <=5 and level != 0:
                print(level,'difficulty level is selected')
            elif level > 5 or level == 0:
                print('not accepted value')

    elif game_select > 3 or game_select == 0:
        print('not accepted value')
