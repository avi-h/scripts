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
        if useryear == 0:
            print("zero?!! no way, try again")
        if useryear < current.year:
            age = current.year - useryear
            print('you are',age,'years old')


    else:
        print('please enter proper data')

    r = input('run again?(y/n):')
    if r != 'y':
        break
