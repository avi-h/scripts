
def calc_age(age):
    days = float(age) * float(365)
    return days


x = input('type your age:')

if x.isnumeric():
    print('you have',int(calc_age(x)),'days so far.')
else:
    print('not valid data')









