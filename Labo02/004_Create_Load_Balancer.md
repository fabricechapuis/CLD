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

# Add rule to DRUPAL Security Group to allow port 8080 from Load Balancer
[INPUT]
aws ec2 authorize-security-group-ingress --group-id sg-0182c5e980d6db02e  --protocol tcp --port 8080 --source-group "sg-02803043caaa4a38f"

[OUTPUT]
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0b50cbada99a10bc1",
            "GroupId": "sg-0182c5e980d6db02e",
            "GroupOwnerId": "709024702237",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 8080,
            "ToPort": 8080,
            "ReferencedGroupInfo": {
                "GroupId": "sg-02803043caaa4a38f",
                "UserId": "709024702237"
            }
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

```PowerShell
[INPUT]
aws elbv2 create-target-group --name "TG-DEVOPSTEAM04" --protocol "HTTP" --port 8080 --vpc-id "vpc-03d46c285a2af77ba" --health-check-protocol "HTTP" --protocol-version "HTTP1" --ip-address-type "ipv4" --target-type "instance" --health-check-path "/" --health-check-port "traffic-port" --healthy-threshold-count 2 --unhealthy-threshold-count 2 --health-check-timeout-seconds 5 --health-check-interval-seconds 10 --matcher "HttpCode=200"

[OUTPUT]
{
    "TargetGroups": [
        {
            "TargetGroupArn": "arn:aws:elasticloadbalancing:eu-west-3:709024702237:targetgroup/TG-DEVOPSTEAM04/a5118a499ec2b2d2",
            "TargetGroupName": "TG-DEVOPSTEAM04",
            "Protocol": "HTTP",
            "Port": 8080,
            "VpcId": "vpc-03d46c285a2af77ba",
            "HealthCheckProtocol": "HTTP",
            "HealthCheckPort": "traffic-port",
            "HealthCheckEnabled": true,
            "HealthCheckIntervalSeconds": 10,
            "HealthCheckTimeoutSeconds": 5,
            "HealthyThresholdCount": 2,
            "UnhealthyThresholdCount": 2,
            "HealthCheckPath": "/",
            "Matcher": {
                "HttpCode": "200"
            },
            "TargetType": "instance",
            "ProtocolVersion": "HTTP1",
            "IpAddressType": "ipv4"
        }
    ]
}
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

[INPUT]
aws elbv2 create-listener --load-balancer-arn "arn:aws:elasticloadbalancing:eu-west-3:709024702237:loadbalancer/app/ELB-DEVOPSTEAM04/5810daca78497bd5" --protocol HTTP --port 8080 --default-actions "Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:eu-west-3:709024702237:targetgroup/TG-DEVOPSTEAM04/a5118a499ec2b2d2,ForwardConfig={TargetGroupStickinessConfig={Enabled=false}}"

[OUTPUT]
{
    "Listeners": [
        {
            "ListenerArn": "arn:aws:elasticloadbalancing:eu-west-3:709024702237:listener/app/ELB-DEVOPSTEAM04/5810daca78497bd5/190e4e0997dd5130",
            "LoadBalancerArn": "arn:aws:elasticloadbalancing:eu-west-3:709024702237:loadbalancer/app/ELB-DEVOPSTEAM04/5810daca78497bd5",
            "Port": 8080,
            "Protocol": "HTTP",
            "DefaultActions": [
                {
                    "Type": "forward",
                    "TargetGroupArn": "arn:aws:elasticloadbalancing:eu-west-3:709024702237:targetgroup/TG-DEVOPSTEAM04/a5118a499ec2b2d2",
                    "ForwardConfig": {
                        "TargetGroups": [
                            {
                                "TargetGroupArn": "arn:aws:elasticloadbalancing:eu-west-3:709024702237:targetgroup/TG-DEVOPSTEAM04/a5118a499ec2b2d2",
                                "Weight": 1
                            }
                        ],
                        "TargetGroupStickinessConfig": {
                            "Enabled": false
                        }
                    }
                }
            ]
        }
    ]
}
```

* Get the ELB FQDN (DNS NAME - A Record)

```bash
[INPUT]
  aws elbv2 describe-load-balancers --names "ELB-DEVOPSTEAM04" --query "LoadBalancers[*].DNSName"

[OUTPUT]
[
    "internal-ELB-DEVOPSTEAM04-637783655.eu-west-3.elb.amazonaws.com"
]
```

* Get the ELB deployment status

Note : In the EC2 console select the Target Group. In the
       lower half of the panel, click on the **Targets** tab. Watch the
       status of the instance go from **unused** to **initial**.

* Ask the DMZ administrator to register your ELB with the reverse proxy via the private teams channel

* Update your string connection to test your ELB and test it

```bash
ssh devopsteam04@15.188.43.46 -i ~/.ssh/cld/CLD_KEY_DMZ_DEVOPSTEAM04.pem -L 2222:10.0.4.10:22 -L 2223:10.0.4.140:22 -L 8080:internal-ELB-DEVOPSTEAM04-637783655.eu-west-3.elb.amazonaws.com:8080
```

* Test your application through your ssh tunneling

```bash
[INPUT]
curl localhost:8080

[OUTPUT]
<Code HTML>
```

#### Questions - Analysis

* On your local machine resolve the DNS name of the load balancer into
  an IP address using the `nslookup` command (works on Linux, macOS and Windows). Write
  the DNS name and the resolved IP Address(es) into the report.

```
Server:         172.30.208.1
Address:        172.30.208.1#53

Non-authoritative answer:
Name:   internal-ELB-DEVOPSTEAM04-637783655.eu-west-3.elb.amazonaws.com
Address: 10.0.4.132
Name:   internal-ELB-DEVOPSTEAM04-637783655.eu-west-3.elb.amazonaws.com
Address: 10.0.4.9
```

* From your Drupal instance, identify the ip from which requests are sent by the Load Balancer.

Help : execute `tcpdump port 8080`

```
10.0.4.9 et 10.0.4.132, which corresponds to the nslookup done earlier.
```

* In the Apache access log identify the health check accesses from the
  load balancer and copy some samples into the report.

```
10.0.4.9 - - [28/Mar/2024:14:16:16 +0000] "GET / HTTP/1.1" 200 5147
10.0.4.132 - - [28/Mar/2024:14:16:19 +0000] "GET / HTTP/1.1" 200 5147
10.0.4.9 - - [28/Mar/2024:14:16:26 +0000] "GET / HTTP/1.1" 200 5147
10.0.4.132 - - [28/Mar/2024:14:16:29 +0000] "GET / HTTP/1.1" 200 5147
10.0.4.9 - - [28/Mar/2024:14:16:36 +0000] "GET / HTTP/1.1" 200 5147
10.0.4.132 - - [28/Mar/2024:14:16:39 +0000] "GET / HTTP/1.1" 200 5147
```
