import os

vm_name = 'ubuntuSRV'
path = 'C:/VirtualBox/Vagrant/' + vm_name
folder_verify = os.path.exists(path)
boxfile = 'vb_ubuntuSRV.box'

if folder_verify == False:
    os.makedirs(vm_name)
    print(path)
    print('Directory', path, 'created.')
else:
    print(path,'already exist.')

