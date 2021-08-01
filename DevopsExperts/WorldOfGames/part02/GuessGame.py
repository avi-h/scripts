while True:
    # -------function----------------
    def generate_number():
        import random
        difficulty = [2, 3, 4, 5, 6, 7, 8, 9, 10]
        num_add = 1
        index = 0
        difficulty.insert(index, int(num_add))

        random.shuffle(difficulty)
        secret_number = int(random.choice(difficulty))

        # function attributes:
        generate_number.max_num = int(max(difficulty))
        generate_number.min_num = int(min(difficulty))
        # --------------------------------------------
        return secret_number
        # ------end of function-----------

    secret_num = generate_number()

    # --------function---------------

    def guess_from_user():
        user_guess = input('type a number from '
                           + str(generate_number.min_num) + ' to '
                           + str(generate_number.max_num) + ':')
        return (user_guess)

    # ------end of function-----------------

    # --------function-----------------------

    def compare_results():

        user_guess = guess_from_user()

        if user_guess.isdigit():
            user_guess = int(user_guess)

            if secret_num == user_guess:
                print('=============================')
                print ('***', True, '***')
                print ('BINGO BINGO, Boom Shakalaka')
                print ('============================')
            else:
                if (user_guess < int(11)) and (user_guess > int(0)):
                    print('==========================')
                    print ('---->', False, '<----')
                    print ('The secret number was:', secret_num)
                    print('===========================')
                elif user_guess == int(0):
                    print ('Zero is not acceptable')
                elif user_guess >= int(11):
                    print ('Your number is too big to fit in here')
        else:
            print ('WRONG: not VALID data')

        # -----end of function

    def play():
        compare_results()

    play()

    retry = input('Try Again?(y/n):')
    if retry != 'y':
        break
