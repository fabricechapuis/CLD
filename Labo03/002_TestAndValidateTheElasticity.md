# Task 003 - Test and validate the elasticity

![Schema](./img/CLD_AWS_INFA.PNG)


## Simulate heavy load to trigger a scaling action

* [Install the package "stress" on your Drupal instance](https://www.geeksforgeeks.org/linux-stress-command-with-examples/)

* [Install the package htop on your Drupal instance](https://www.geeksforgeeks.org/htop-command-in-linux-with-examples/)

* Check how many vCPU are available (with htop command)

```
[INPUT]
htop

[OUTPUT]
//copy the part representing vCPus, RAM and swap usage
```

![htop](./img/htop.png)

### Stress your instance

```
[INPUT]
//stress command

[OUTPUT]
//copy the part representing vCPus, RAM and swap usage
//tip : use two ssh sessions....
```

![htop stressed](./img/htop-stress.png)

* (Scale-IN) Observe the autoscaling effect on your infa


```
[INPUT]
//Screen shot from cloud watch metric
```
[Sample](./img/CLD_AWS_CLOUDWATCH_CPU_METRICS.PNG)
![cloud watch metric](./img/cloudwatch-metric.png)

```
//screenshot of ec2 instances list (running state)
```
[Sample](./img/CLD_AWS_EC2_LIST.PNG)
![ec2 instances list](./img/instances.png)

```
//Validate that the various instances have been distributed between the two available az.
[INPUT]
//aws cli command

[OUTPUT]
```

![instace availability zones](./img/instances.png)

```
//screenshot of the activity history
```
[Sample](./img/CLD_AWS_ASG_ACTIVITY_HISTORY.PNG)
![activity history](./img/activity-history.png)

```
//screenshot of the cloud watch alarm target tracking
```
[Sample](./img/CLD_AWS_CLOUDWATCH_ALARMHIGH_STATS.PNG)
![alarm target tracking](./img/asgrp-metric.png)


* (Scale-OUT) As soon as all 4 instances have started, end stress on the main machine.

[Change the default cooldown period](https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-scaling-cooldowns.html)

```
//screenshot from cloud watch metric
```
![alarm target tracking low](./img/asgrp-metric-low.png)

```
//screenshot of ec2 instances list (terminated state)
// Deduced from activity history, instanced were already deleted from the list
```

```
//screenshot of the activity history
```
![full activity history](./img/full-activity-history.png)

## Release Cloud resources

Once you have completed this lab release the cloud resources to avoid
unnecessary charges:

* Terminate the EC2 instances.
    * Make sure the attached EBS volumes are deleted as well.
* Delete the Auto Scaling group.
* Delete the Elastic Load Balancer.
* Delete the RDS instance.

(this last part does not need to be documented in your report.)

## Delivery

Inform your teacher of the deliverable on the repository (link to the commit to retrieve)