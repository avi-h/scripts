import boto3

EC2_RESOURCE = boto3.resource('ec2')
INSTANCE_ID = None

instance = EC2_RESOURCE.Instance(INSTANCE_ID)

device_mappings = instance.block_device_mappings

print(f'Volumes attached to the EC2 instance "{INSTANCE_ID}":')

for device in device_mappings:
    print(f"  - Volume {device['Ebs']['VolumeId']} attached as {device['DeviceName']}")