import os, requests, json
import vagrant

vm_name = 'ubuntuSRV'
path = 'C:\\VirtualBox\\Vagrant\\' + vm_name
folder_verify = os.path.exists(path)
boxfile = 'vb_ubuntuSRV.box'
provider = 'virtualbox'

if folder_verify == False:
    os.makedirs(path)
    print('Directory', path, 'created.')
else:
    print(path,'already exist.')

box_name = os.system('vagrant box list')
verify_box = os.path.exists(path + '\\' + boxfile)





