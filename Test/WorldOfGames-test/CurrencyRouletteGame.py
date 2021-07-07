import random

difficulty = 3
USD_value = 0


def generate_USD_value():
    global USD_value
    USD_value = random.randint(1, 101)


def get_money_interval(currency_rate):
    return (USD_value*currency_rate - 5 + difficulty,USD_value*currency_rate + 5 - difficulty )


def get_guess_from_user():
    no_exception = False  # Flag to keep info whether exception was thrown or not
    while no_exception == False:
        print("You chose Currency Roulette Game. Please type your guess of ILS value of " + str(USD_value) + " $ : ")
        try:
            user__guess = float(input(">>>"))
            no_exception = True  # The exception was not thrown, so the loop will be finished.
        except ValueError as e:
            print("\t\t!!!!!!!!!!!!!!!   " + str(e) + "    !!!!!!!!!!!!!!!!!\n")
    return user__guess

def play():
    generate_USD_value()
    guess_from_user = get_guess_from_user()
    lower_interval  = get_money_interval(3.6)[0]
    upper_interval = get_money_interval(3.6)[1]
    print("Interval that system chose is (" + str("{:3.2f}".format(lower_interval)) + "," +
          str("{:3.2f}".format(upper_interval)) + ") , and your guess is " + str(guess_from_user) + ".")
    return (guess_from_user <= upper_interval) & (guess_from_user >= lower_interval)


def set_difficulty(difficulty_value):
    global difficulty
    difficulty = difficulty_value

play()