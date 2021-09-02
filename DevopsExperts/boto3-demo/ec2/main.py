from create_ec2_instance import create_instance
from create_sg import create_security_group as create_security_group
import boto3
import uuid
import time
from ssh import set_machine
ip_addr = input("insert your ip:\n")
security_group_name = str(uuid.uuid4())[:8]

ec2_client = boto3.resource('ec2')
client = boto3.client('ec2')
security_group = create_security_group(security_group_name,ip_addr)
instance = create_instance(security_group=security_group.id,key_name="ubuntu-devops-experts")
instance.wait_until_running()
instance.load()
print(f"created instance with id: {instance.id}")
time.sleep(60)
set_machine(address=instance.public_dns_name)
print(instance.public_dns_name)

print(instance.terminate())
security_group.revoke_ingress(IpPermissions=security_group.ip_permissions)
print(client.delete_security_group(GroupId=security_group.id))
