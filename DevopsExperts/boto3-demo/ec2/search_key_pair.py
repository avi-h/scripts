import boto3

AWS_REGION = "us-east-1"
EC2_RESOURCE = boto3.resource('ec2', region_name=AWS_REGION)

key_pairs = EC2_RESOURCE.key_pairs.filter(
    KeyNames=[
        'vbox-ubuntu18-work-machine',
    ],
)

for key in key_pairs:
    print(f'SSH key "{key.key_name}" fingerprint: {key.key_fingerprint}')