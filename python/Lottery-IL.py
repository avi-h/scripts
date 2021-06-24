def loterry_IL():

    while True:
        import random
        print('==================================')
        print('*** Guessing lottery results ***')
        print('==================================')



        for x in range(6):
            x = random.randint(1,37)
            print(x)

        for y in range(1):
            y = random.randint(1,7)
            print('Extra number:',y)
            print('======================')
            print('*** Best Of Luck ***')
            print('======================')

        run_again = input('run again?(y/n):')
        if run_again != 'y':
            break

loterry_IL()

