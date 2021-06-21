passwd = str(1234)
useryear = int(input('year of birth:'))

from datetime import date

today = date.today()

age = today.year - useryear

if useryear > today.year:
    print('ERROR:input value greater then', today.year)

r = input('run again?(y/n):')
