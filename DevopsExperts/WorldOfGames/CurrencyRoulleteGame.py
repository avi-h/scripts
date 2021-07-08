import random,json,requests

difficulty = 3

def generate_usd_amount():
    usd_amount = random.randint(1,101)
    return usd_amount


def get_money_interval():
    difficulty = 3
    from_rate = 'usd'
    url = 'https://open.er-api.com/v6/latest/'
    results = requests.request('GET', url + from_rate.upper())
    currency_dict_all = json.loads(results.text)
    dict_rates = currency_dict_all.get('rates')
    rate_ils = dict_rates.get('ILS')
    return rate_ils

    #return int((usd_value*rate_ils - 5 + difficulty)), int((usd_value*rate_ils + 5 - difficulty ))


def get_guess_from_user():
    global user_guess
    usd_amount = generate_usd_amount()
    no_exception = False
    while no_exception == False:
        try:
            user_guess = float(input("type your guess of ILS value for " + str(usd_amount) + " $ : "))
            no_exception = True
        except ValueError as err:
            print(err)

    rate_ils = get_money_interval()

    system_guess = float(usd_amount * rate_ils - 5 + difficulty), \
                   float(usd_amount * rate_ils + 5 + difficulty)

    print('Your Guess:', user_guess)
    print('system guess:', system_guess)


def play():
    get_guess_from_user()


play()




