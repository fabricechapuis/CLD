### Deploy the elastic load balancer

In this task you will create a load balancer in AWS that will receive
the HTTP requests from clients and forward them to the Drupal
instances.

![Schema](./img/CLD_AWS_INFA.PNG)

## Task 01 Prerequisites for the ELB

* Create a dedicated security group

|Key|Value|
|:--|:--|
|Name|SG-DEVOPSTEAM[XX]-LB|
|Inbound Rules|Application Load Balancer|
|Outbound Rules|Refer to the infra schema|

```bash
[INPUT]
aws ec2 create-security-group --description "Allow access to ELB" --group-name "SG-DEVOPSTEAM04-LB" --vpc-id vpc-03d46c285a2af77ba --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=SG-DEVOPSTEAM04-LB}]"

[OUTPUT]
{
    "GroupId": "sg-02803043caaa4a38f",
    "Tags": [
        {
            "Key": "Name",
            "Value": "SG-DEVOPSTEAM04-LB"
        }
    ]
}

[INPUT]
aws ec2 authorize-security-group-ingress --group-id sg-02803043caaa4a38f  --protocol tcp --port 8080 --cidr 10.0.4.0/28

[OUTPUT]
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-04ae1ccf98f440fa3",
            "GroupId": "sg-02803043caaa4a38f",
            "GroupOwnerId": "709024702237",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 8080,
            "ToPort": 8080,
            "CidrIpv4": "10.0.4.0/28"
        }
    ]
}


[INPUT]
aws ec2 authorize-security-group-ingress --group-id sg-02803043caaa4a38f  --protocol tcp --port 8080 --cidr 10.0.4.128/28

[OUTPUT]
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-030dbdb6766a02e66",
            "GroupId": "sg-02803043caaa4a38f",
            "GroupOwnerId": "709024702237",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 8080,
            "ToPort": 8080,
            "CidrIpv4": "10.0.4.128/28"
        }
    ]
}


[INPUT]
aws ec2 authorize-security-group-ingress --group-id sg-02803043caaa4a38f  --protocol tcp --port 8080 --cidr 10.0.0.0/28

[OUTPUT]
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0f97c3393a8f4bfba",
            "GroupId": "sg-02803043caaa4a38f",
            "GroupOwnerId": "709024702237",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 8080,
            "ToPort": 8080,
            "CidrIpv4": "10.0.0.0/28"
        }
    ]
}


```

* Create the Target Group

|Key|Value|
|:--|:--|
|Target type|Instances|
|Name|TG-DEVOPSTEAM[XX]|
|Protocol and port|Refer to the infra schema|
|Ip Address type|IPv4|
|VPC|Refer to the infra schema|
|Protocol version|HTTP1|
|Health check protocol|HTTP|
|Health check path|/|
|Port|Traffic port|
|Healthy threshold|2 consecutive health check successes|
|Unhealthy threshold|2 consecutive health check failures|
|Timeout|5 seconds|
|Interval|10 seconds|
|Success codes|200|

```bash
[INPUT]


[OUTPUT]

```


## Task 02 Deploy the Load Balancer

[Source](https://aws.amazon.com/elasticloadbalancing/)

* Create the Load Balancer

|Key|Value|
|:--|:--|
|Type|Application Load Balancer|
|Name|ELB-DEVOPSTEAM04|
|Scheme|Internal|
|Ip Address type|IPv4|
|VPC|Refer to the infra schema|
|Security group|Refer to the infra schema|
|Listeners Protocol and port|Refer to the infra schema|
|Target group|Your own target group created in task 01|

Provide the following answers (leave any
field not mentioned at its default value):

```bash
[INPUT]
aws elbv2 create-load-balancer --name "ELB-DEVOPSTEAM04" --scheme "internal" --ip-address-type "ipv4" --security-groups sg-02803043caaa4a38f --subnets "subnet-0bf85ea7e03762d3c" "subnet-0ae5546979aecf3f2" --tags "Key=VpcId,Value=vpc-03d46c285a2af77ba"

[OUTPUT]
{
    "LoadBalancers": [
        {
            "LoadBalancerArn": "arn:aws:elasticloadbalancing:eu-west-3:709024702237:loadbalancer/app/ELB-DEVOPSTEAM04/5810daca78497bd5",
            "DNSName": "internal-ELB-DEVOPSTEAM04-637783655.eu-west-3.elb.amazonaws.com",
            "CanonicalHostedZoneId": "Z3Q77PNBQS71R4",
            "CreatedTime": "2024-03-28T12:35:03.410000+00:00",
            "LoadBalancerName": "ELB-DEVOPSTEAM04",
            "Scheme": "internal",
            "VpcId": "vpc-03d46c285a2af77ba",
            "State": {
                "Code": "provisioning"
            },
            "Type": "application",
            "AvailabilityZones": [
                {
                    "ZoneName": "eu-west-3b",
                    "SubnetId": "subnet-0ae5546979aecf3f2",
                    "LoadBalancerAddresses": []
                },
                {
                    "ZoneName": "eu-west-3a",
                    "SubnetId": "subnet-0bf85ea7e03762d3c",
                    "LoadBalancerAddresses": []
                }
            ],
            "SecurityGroups": [
                "sg-02803043caaa4a38f"
            ],
            "IpAddressType": "ipv4"
        }
    ]
}


```

* Get the ELB FQDN (DNS NAME - A Record)

```bash
[INPUT]


[OUTPUT]

```

* Get the ELB deployment status

Note : In the EC2 console select the Target Group. In the
       lower half of the panel, click on the **Targets** tab. Watch the
       status of the instance go from **unused** to **initial**.

* Ask the DMZ administrator to register your ELB with the reverse proxy via the private teams channel

* Update your string connection to test your ELB and test it

```bash
//connection string updated
```

* Test your application through your ssh tunneling

```bash
[INPUT]
curl localhost:[local port forwarded]

[OUTPUT]

```

#### Questions - Analysis

* On your local machine resolve the DNS name of the load balancer into
  an IP address using the `nslookup` command (works on Linux, macOS and Windows). Write
  the DNS name and the resolved IP Address(es) into the report.

```
//TODO
```

* From your Drupal instance, identify the ip from which requests are sent by the Load Balancer.

Help : execute `tcpdump port 8080`

```
//TODO
```

* In the Apache access log identify the health check accesses from the
  load balancer and copy some samples into the report.

```
//TODO
```
