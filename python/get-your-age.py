while True:
    from datetime import date
    current = date.today()
    useryear = input('year of birth(XXXX):')
    if useryear.isdigit():
        useryear = int(useryear)
        if useryear > current.year:
            print('ERROR:year of birth is higher from current year')
        if useryear == current.year:
            print('Welcome to',current.year,'Baby!')

        if (useryear < current.year) and (useryear != 0):
            age = current.year - useryear
            print('you are', age, 'year old')
        if useryear == 0:
            print("zero?!! no way, try again")

    else:
        print('please enter proper data')

    r = input('run again?(y/n):')
    if r != 'y':
        break
