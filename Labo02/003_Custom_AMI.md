# Custom AMI and Deploy the second Drupal instance

In this task you will update your AMI with the Drupal settings and deploy it in the second availability zone.

## Task 01 - Create AMI

### [Create AMI](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-image.html)

Note : stop the instance before

|Key|Value for GUI Only|
|:--|:--|
|Name|AMI_DRUPAL_DEVOPSTEAM[XX]_LABO02_RDS|
|Description|Same as name value|

```bash
[INPUT]
aws ec2 create-image --instance-id "i-0136e53ee54579b1d" --name "AMI_DRUPAL_DEVOPSTEAM04_LABO02_RDS" --description "AMI_DRUPAL_DEVOPSTEAM04_LABO02_RDS" --tag-specifications "ResourceType=image,Tags=[{Key=Name,Value=AMI_DRUPAL_DEVOPSTEAM04_LABO02_RDS}]"

[OUTPUT]
{
    "ImageId": "ami-044cc285ccc48da48"
}
```

## Task 02 - Deploy Instances

* Restart Drupal Instance in Az1

* Deploy Drupal Instance based on AMI in Az2

|Key|Value for GUI Only|
|:--|:--|
|Name|EC2_PRIVATE_DRUPAL_DEVOPSTEAM[XX]_B|
|Description|Same as name value|

```bash
[INPUT]
aws ec2 run-instances --image-id "ami-044cc285ccc48da48" --count 1 --instance-type "t3.micro" --key-name "CLD_KEY_DRUPAL_DEVOPSTEAM04" --security-group-ids "sg-0182c5e980d6db02e" --subnet-id "subnet-0ae5546979aecf3f2" --private-ip-address "10.0.4.140" --block-device-mappings '{\"DeviceName\":\"/dev/xvda\",\"Ebs\":{\"VolumeSize\":10,\"VolumeType\":\"gp3\"}}' --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=EC2_PRIVATE_DRUPAL_DEVOPSTEAM04_B}]"

[OUTPUT]
{
    "Groups": [],
    "Instances": [
        {
            "AmiLaunchIndex": 0,
            "ImageId": "ami-044cc285ccc48da48",
            "InstanceId": "i-005ac5d0bcc27525a",
            "InstanceType": "t3.micro",
            "KeyName": "CLD_KEY_DRUPAL_DEVOPSTEAM04",
            "LaunchTime": "2024-03-21T16:38:37+00:00",
            "Monitoring": {
                "State": "disabled"
            },
            "Placement": {
                "AvailabilityZone": "eu-west-3b",
                "GroupName": "",
                "Tenancy": "default"
            },
            "PrivateDnsName": "ip-10-0-4-140.eu-west-3.compute.internal",
            "PrivateIpAddress": "10.0.4.140",
            "ProductCodes": [],
            "PublicDnsName": "",
            "State": {
                "Code": 0,
                "Name": "pending"
            },
            "StateTransitionReason": "",
            "SubnetId": "subnet-0ae5546979aecf3f2",
            "VpcId": "vpc-03d46c285a2af77ba",
            "Architecture": "x86_64",
            "BlockDeviceMappings": [],
            "ClientToken": "38543012-6509-4b17-8f14-0c481be0e744",
            "EbsOptimized": false,
            "EnaSupport": true,
            "Hypervisor": "xen",
            "NetworkInterfaces": [
                {
                    "Attachment": {
                        "AttachTime": "2024-03-21T16:38:37+00:00",
                        "AttachmentId": "eni-attach-0dcedd2d758a7b8e4",
                        "DeleteOnTermination": true,
                        "DeviceIndex": 0,
                        "Status": "attaching",
                        "NetworkCardIndex": 0
                    },
                    "Description": "",
                    "Groups": [
                        {
                            "GroupName": "SG-PRIVATE-DRUPAL-DEVOPSTEAM04",
                            "GroupId": "sg-0182c5e980d6db02e"
                        }
                    ],
                    "Ipv6Addresses": [],
                    "MacAddress": "0a:c8:fd:9c:59:f3",
                    "NetworkInterfaceId": "eni-0ea336ebc39dd239f",
                    "OwnerId": "709024702237",
                    "PrivateIpAddress": "10.0.4.140",
                    "PrivateIpAddresses": [
                        {
                            "Primary": true,
                            "PrivateIpAddress": "10.0.4.140"
                        }
                    ],
                    "SourceDestCheck": true,
                    "Status": "in-use",
                    "SubnetId": "subnet-0ae5546979aecf3f2",
                    "VpcId": "vpc-03d46c285a2af77ba",
                    "InterfaceType": "interface"
                }
            ],
            "RootDeviceName": "/dev/xvda",
            "RootDeviceType": "ebs",
            "SecurityGroups": [
                {
                    "GroupName": "SG-PRIVATE-DRUPAL-DEVOPSTEAM04",
                    "GroupId": "sg-0182c5e980d6db02e"
                }
            ],
            "SourceDestCheck": true,
            "StateReason": {
                "Code": "pending",
                "Message": "pending"
            },
            "Tags": [
                {
                    "Key": "Name",
                    "Value": "EC2_PRIVATE_DRUPAL_DEVOPSTEAM04_B"
                }
            ],
            "VirtualizationType": "hvm",
            "CpuOptions": {
                "CoreCount": 1,
                "ThreadsPerCore": 2
            },
            "CapacityReservationSpecification": {
                "CapacityReservationPreference": "open"
            },
            "MetadataOptions": {
                "State": "pending",
                "HttpTokens": "optional",
                "HttpPutResponseHopLimit": 1,
                "HttpEndpoint": "enabled",
                "HttpProtocolIpv6": "disabled",
                "InstanceMetadataTags": "disabled"
            },
            "EnclaveOptions": {
                "Enabled": false
            },
            "PrivateDnsNameOptions": {
                "HostnameType": "ip-name",
                "EnableResourceNameDnsARecord": false,
                "EnableResourceNameDnsAAAARecord": false
            },
            "MaintenanceOptions": {
                "AutoRecovery": "default"
            },
            "CurrentInstanceBootMode": "legacy-bios"
        }
    ],
    "OwnerId": "709024702237",
    "ReservationId": "r-060e03ba80a052b23"
}
```

## Task 03 - Test the connectivity

### Update your ssh connection string to test

* add tunnels for ssh and http pointing on the B Instance

```bash
ssh devopsteam04@15.188.43.46 -i ~/.ssh/cld/CLD_KEY_DMZ_DEVOPSTEAM04.pem -L 2222:10.0.4.10:22 -L 8080:10.0.4.10:8080 -L 2223:10.0.4.140:22 -L 8081:10.0.4.140:8080
```

## Check SQL Accesses

```sql
[INPUT]
mariadb -h dbi-devopsteam04.cshki92s4w5p.eu-west-3.rds.amazonaws.com -u bn_drupal -p

[OUTPUT]
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 237
Server version: 10.11.7-MariaDB managed by https://aws.amazon.com/rds/

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>
```

```sql
[INPUT]
mariadb -h dbi-devopsteam04.cshki92s4w5p.eu-west-3.rds.amazonaws.com -u bn_drupal -p

[OUTPUT]
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 233
Server version: 10.11.7-MariaDB managed by https://aws.amazon.com/rds/

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>
```

Not the same id (237 and 233), therefore not the same user (10.0.4.10 opposed to 10.0.4.140, from 2 different subnets)

### Check HTTP Accesses

```bash
curl localhost:8080
curl localhost:8081
```

### Read and write test through the web app

* Login in both webapps (same login)

* Change the users' email address on a webapp... refresh the user's profile page on the second and validated that they are communicating with the same db (rds).

* Observations ?

```
The email address also changes in the second instance, meaning they both get their information from the same database.
```

### Change the profil picture

* Observations ?

```
The 2nd instance looks for the image but doesn't find any. Probably because Drupal is initially setup locally and most likely saves the image locally in the instance and the DB most likely save the path. But when the 2nd instance tries to look to this path, he finds nothing and therefore shows that something should load but no image is found.
```