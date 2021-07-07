import MemoryGame
import GuessGame
import CurrencyRouletteGame
import Score

# Function to welcome a player. It gets name and prints greeting
def welcome(name) :
    return "\nHello " + name + " and welcome to the world of Games (WoG). \nHere you can find many cool games to play\n"


# Function to get a player to choose which play he will play and what difficulty level it will be.
def load_game() :
    no_exception = False                     # Flag to keep info whether exception was thrown or not
    while no_exception == False:
        print("Please choose a game to play: \n"
              "\t1. Memory Game - a sequence of  numbers  will appear for 1 second and you have to guess it back \n"
              "\t2. Guess Game - guess a number and see if you  chose like the computer \n"
              "\t3. Currency  Roulette - try and guess the value of a random amount of USD in ILS")
        try:
             user__game_choice = int(input(">>>"))
             if user__game_choice not in range (1,4):
                raise ValueError
             else:
                 no_exception = True        # The exception was not thrown, so the loop will be finished.
        except ValueError as e:
                print("\t\t!!!!!!!!!!!!!!!   Numbers 1, 2, 3 are only allowed   !!!!!!!!!!!!!!!!!\n")

    no_exception = False                    # Flag to keep info whether exception was thrown or not
    while no_exception == False:
        print("Please choose game difficulty from 1 to 5:")
        try:
            user__dificulty_choice = int(input(">>>"))
            if user__dificulty_choice not in range (1,6):
                raise ValueError
            else:
                no_exception = True         # The exception was not thrown, so the loop will be finished.
        except ValueError as e:
                print("\t\t!!!!!!!!!!!!!!!   Numbers from 1 to 5 are only allowed   !!!!!!!!!!!!!!!!!\n")

    if user__game_choice == 2:
        GuessGame.set_difficulty(user__dificulty_choice)
        result = GuessGame.play()
    elif user__game_choice == 1:
        MemoryGame.set_difficulty(user__dificulty_choice)
        result = MemoryGame.play()
    elif user__game_choice == 3:
        CurrencyRouletteGame.set_difficulty(user__dificulty_choice)
        result = CurrencyRouletteGame.play()

    if result == True:
        print("                                     You won")
        Score.add_score(user__dificulty_choice)
    else:
        print("                                     You lost")
        Score.create_zero_score()


