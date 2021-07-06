def currency_calc():

    try:

        import requests,json

        #get currency API and add to a dictionary:

        from_rate = input(str('From Currency:'))
        to_rate = input(str('To Currency:'))
        url = 'https://open.er-api.com/v6/latest/'
        results = requests.request('GET', url+from_rate.upper())

        #### create filter the results to dictionaries ###########

        currency_dict_all = json.loads(results.text)
        currency_from = currency_dict_all['base_code']
        currency_to_all = (currency_dict_all['rates'])
        currency_to_desired = currency_to_all[to_rate.upper()]

        #### print the results #######

        print(1,currency_from,'=',currency_to_desired,to_rate.upper())
    except KeyError:
        print('ERROR:currency was not found')
    except:
        print('ERROR:wrong input')

currency_calc()

#another method to convert currency:
#from currency_converter import CurrencyConverter
