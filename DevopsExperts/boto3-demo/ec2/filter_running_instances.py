import boto3

EC2_RESOURCE = boto3.resource('ec2')
INSTANCE_STATE = 'running'

instances = EC2_RESOURCE.instances.filter(
    Filters=[
        {
            'Name': 'instance-state-name',
            'Values': [
                INSTANCE_STATE
            ]
        }
    ]
)

print(f'Instances in state "{INSTANCE_STATE}":')

for instance in instances:
    print(f'  - Instance ID: {instance.id}')