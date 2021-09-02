import boto3

AWS_REGION = "us-east-2"
EC2_RESOURCE = boto3.resource('ec2')
INSTANCE_ID = None

instance = EC2_RESOURCE.Instance(INSTANCE_ID)

instance.terminate()

print(f'Terminating EC2 instance: {instance.id}')

instance.wait_until_terminated()

print(f'EC2 instance "{instance.id}" has been terminated')