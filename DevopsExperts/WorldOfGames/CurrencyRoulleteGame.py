import random

difficulty = 3
usd_value = 0


def generate_USD_value():
    global usd_value
    usd_value = random.randint(1, 101)


def get_money_interval(currency_rate):



    return (usd_value*currency_rate - 5 + difficulty,usd_value*currency_rate + 5 - difficulty )


def get_guess_from_user():
    global user__guess
    no_exception = False  # flag to keep exception info
    while not no_exception:
        print("type your guess of ILS value of " + str(usd_value) + " $ : ")
        try:
            user__guess = float(input(">>>"))
            no_exception = True  # The exception was not thrown, so the loop will be finished.
        except ValueError as e:
            print(str(e))
    return user__guess

def play():
    generate_USD_value()
    guess_from_user = get_guess_from_user()
    lower_interval  = get_money_interval(0)[0]
    upper_interval = get_money_interval(0)[1]
    print("system interval: (" + str("{:3.2f}".format(lower_interval)) + "," +
          str("{:3.2f}".format(upper_interval)) + ")\nyour guess: "
          + str(guess_from_user))
    return (guess_from_user <= upper_interval) &\
           (guess_from_user >= lower_interval)


play()

