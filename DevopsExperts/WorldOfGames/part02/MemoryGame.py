#create number list & shuffle
def generate_sequence():
    import random
    sequence = list(range(1, 102))
    random.shuffle(sequence)
    return sequence

#get level input from user
def list_from_user():
    import random
    difficulty_user = input('How many numbers would you like to guess(up to 101)?')
    if difficulty_user.isdigit():
        difficulty = difficulty_user
        difficulty = int(difficulty)
        if (difficulty < 102) and (difficulty != 0):
            return difficulty
        else:
            return 'Value not accepted'
    else:
        return 'Value not accepted'

#compare the results
def is_list_equal():

    try:
        import random,time
        memo_time = float(0.7)
        all_numbers = generate_sequence()
        user_choice = list_from_user()
        user_choice = int(user_choice)
        difficulty = user_choice
        game_nums = random.sample(all_numbers, difficulty)
        print('displaying', difficulty, 'numbers for', memo_time, 'seconds...')
        print(game_nums)
        time.sleep(memo_time)
        for hide_me in range(0, 1000):
            print('')

        user_num = []
        i = int(0)
        for index in game_nums:
            i = i + + 1
            index = int(input('Enter Your Number('+str(i)+'):'))
            user_num.append(index)

        user_num.sort()
        game_nums.sort()

        if user_num == game_nums:
            print('===============')
            print('**** TRUE ****')
            print('===============')
            print('Your Numbers:', user_num)
            print('My Numbers:', game_nums)
        else:
            print('=================')
            print('----> FALSE <----')
            print('=================')
            print('Your answer:', user_num)
            print('Correct Numbers:', game_nums)

    except ValueError:
        return 'ERROR: Value not Accepted'

def play():
    while True:
        is_list_equal()
        retry = input('Try again(y/n)?')
        if retry != 'y':
            break

play()
