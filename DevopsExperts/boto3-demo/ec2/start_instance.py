import boto3

AWS_REGION = "us-east-1"
EC2_RESOURCE = boto3.resource('ec2')
INSTANCE_ID = "i-08f85c485c24fae5b"

instance = EC2_RESOURCE.Instance(INSTANCE_ID)

instance.start()

print(f'Starting EC2 instance: {instance.id}')

instance.wait_until_running()

print(f'EC2 instance "{instance.id}" is running')