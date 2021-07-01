while True:

    import random
    difficulty = [2, 3, 4, 5, 6, 7, 8, 9, 10]
    num_to_add = int(1)
    index = 0
    difficulty.insert(index, num_to_add)

    random.shuffle(difficulty)

    max_num = max(difficulty)
    min_num = min(difficulty)

    for secret_num in difficulty:
        continue

    guess_from_user = input('type a number from '
                            + str(min_num) + ' to ' + str(max_num) + ':')

    if guess_from_user.isdigit():
        guess_from_user = int(guess_from_user)

        if secret_num == guess_from_user:
            print('***', True, '***')
            print('===============')
            print('Boom Shakalaka')
            print('===============')
        else:
            if (guess_from_user < int(11)) and (guess_from_user > int(0)):
                print('---->', False, '<----')
                print('The secret number was:', secret_num)
            elif guess_from_user == int(0):
                print('Zero is not acceptable')
            elif guess_from_user >= int(11):
                print('Your number is too big to fit in here')
    else:
        print('WRONG: not VALID data')

    retry = input('Try Again?(y/n):')
    if retry != 'y':
        break















