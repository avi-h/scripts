
try:
    import os
    myfile = open('names.txt', 'w')
    srv = os.system('powershell get-service')
    print('-------------------------------------------')
    print(srv)

except:
    print('Error')
finally:
    myfile.close()

print('----------------------------')

try:
    # "as" + 5
    raise IOError("Invalid value")
except TypeError:
    print("Invalid operation")
    exit(1)
except ValueError:
    print("Value Error")
except:
    print("General error")

print('------------------------------------')
def get_num_from_user():
    user_num = int(input("Please type a positive number:\n"))
    return user_num


def validate(userNum):
    if userNum < 1:
        raise ValueError("you have entered a non positive number:", userNum)
    print("You have entered {0} which is fine by me".format(userNum))


while True:
    try:
        num = get_num_from_user()
        validate(num)
        break
    except ValueError as err:
        print(err)



