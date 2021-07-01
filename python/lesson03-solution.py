#1+2.

try:

    a = 1/0

except:
    print('you cant divide by ZERO')


#3.

try:
    x=1
finally:
    print('finally')

# YES , try goes like try --> finally as well...

#4.
# any exception type.

#5.
# it doesnt give us enough details /info about the error ("bad practice").

#6.
# except IOError: - catch ONLY the IOError exception (error) type .
# # except ZeroDevisionError: - catch ONLY the ZeroDevisionError exception (error) type.
#7-10.
try:
    import codecs
    file_path = "c:/Data/Bullshit/words.txt"
    heb_words = 'פייתון עברית מינוס'
    f  = open(file_path, 'w')
    f.write('Name: Avi\nSurname: Habaza\n')
    #f.write(heb_words)
    f = open(file_path, 'r', encoding=('utf-8'))
    print('===========================')
    print(f.read())
    print('===========================')
    f.close()
except FileNotFoundError:
    print('ERROR: file or directory cant be found. check FILE_PATH variable')
except UnicodeError:
    print('ERROR: cant define Encoding.')

import PIL
from PIL import image
