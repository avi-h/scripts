import boto3

AWS_REGION = "us-east-1"
EC2_RESOURCE = boto3.resource('ec2')
INSTANCE_ID = None

instance = EC2_RESOURCE.Instance(INSTANCE_ID)

instance.stop()

print(f'Stopping EC2 instance: {instance.id}')

instance.wait_until_stopped()

print(f'EC2 instance "{instance.id}" has been stopped')