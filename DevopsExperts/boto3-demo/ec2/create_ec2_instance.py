import boto3


def create_instance(security_group,key_name):
    ec2_client = boto3.resource("ec2")
    response = ec2_client.create_instances(
        ImageId="ami-0c2b8ca1dad447f8a",
        MinCount=1,
        MaxCount=1,
        InstanceType="t2.micro",
        KeyName=key_name,
        SecurityGroupIds=[
            security_group,
        ],
        BlockDeviceMappings = [{"DeviceName": "/dev/xvda", "Ebs": {"VolumeSize": 10}}]
    )
    instance_ = response[0]
    return instance_
