def loterry_il():

    while True:
        import random
        print('==================================')
        print('*** Guessing lottery results ***')
        print('==================================')

        for one_num in range(6):
            one_num = random.randint(1,37)

            print(one_num)

        for extra_num in range(1):
            extra_num = random.randint(1,7)
            print('Extra number:',extra_num)
            print('======================')
            print('*** Best Of Luck ***')
            print('======================')

        run_again = input('run again?(y/n):')
        if run_again != 'y':
            break

loterry_il()

