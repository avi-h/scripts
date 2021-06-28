def loterry_il():
    while True:
        import random
        print('==================================')
        print('*** Guessing lottery results ***')
        print('==================================')

        numbers01 = list((1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
                          , 14, 15, 16, 17, 18, 19, 20, 21,
                          22, 23, 24, 25, 26, 27, 28, 29,
                          30, 31, 32, 33, 34, 35, 36, 37))

        print('******************')

        numbers02 = random.shuffle(numbers01)
        print(numbers02)
        type(numbers02)
        type(numbers01)
        print('*********************')

        for number in range(6):
            number = random.randint(1, 37)

            print(number)

        for extra_num in range(1):
            extra_num = random.randint(1, 7)
            print('Extra number:', extra_num)
            print('======================')
            print('*** Best Of Luck ***')
            print('======================')

        run_again = input('run again?(y/n):')
        if run_again != 'y':
            break


loterry_il()





