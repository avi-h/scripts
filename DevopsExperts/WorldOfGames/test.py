def get_money_interval():
    usd_value = random.randint(1, 101)
    from_rate = 'usd'
    url = 'https://open.er-api.com/v6/latest/'
    results = requests.request('GET', url + from_rate.upper())
    currency_dict_all = json.loads(results.text)
    dict_rates = currency_dict_all.get('rates')
    rate_ils = dict_rates.get('ILS')

    return ((usd_value*rate_ils - 5 + difficulty),(usd_value*rate_ils + 5 ))