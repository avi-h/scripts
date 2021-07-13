import os
txt_name = 'CurrentUser.txt'
txt_path = 'C:/jenkins/MyLab/Scripts/Lesson05/CurrentUser.txt'
txt_verify = os.path.exists(txt_path)
dir_path = 'c:/jenkins/MyLab/Scripts/Lesson05/TestFolder/'

if txt_verify:
    print(txt_name,' file was found at:',txt_path.replace(txt_name,''))
    dir_verify = os.path.exists(dir_path)

    if dir_verify == False:
        print('creating new directory at: ',dir_path)
        os.mkdir(dir_path)
        print('moving ',txt_name,' file to: ',dir_path)
        os.rename(txt_path, dir_path + txt_name)

        txt_new_path = os.path.exists(dir_path+txt_name)
        if txt_new_path:
            print('file was found at: ',dir_path+txt_name)

        else:
            print(dir_path+txt_name,' not found')

    elif dir_verify == True:
        txt_new_path = os.path.exists(dir_path + txt_name)
        txt_old_path = os.path.exists(txt_path)

        if txt_new_path:
            os.remove(dir_path + txt_name)

        if txt_old_path:
            print('moving ',txt_path,'to: ',dir_path)
            os.rename(txt_path, dir_path + txt_name)
            dirfile = os.path.exists(dir_path+txt_path)
            

        else:
            print(txt_path,' doesnt exist')

else:
    print('file not found')