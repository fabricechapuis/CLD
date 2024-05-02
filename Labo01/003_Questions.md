* What is the smallest and the biggest instance type (in terms of
  virtual CPUs and memory) that you can choose from when creating an
  instance?

```
smallest: t2.nano
x2iedn.metal
```

* How long did it take for the new instance to get into the _running_
  state?

```
now as we are doing it outside the labo hours, it takes only 5 secs. When we were on labo's hours, it took more than one minute.
```

* Using the commands to explore the machine listed earlier, respond to
  the following questions and explain how you came to the answer:

    * What's the difference between time here in Switzerland and the time set on
      the machine?
      
    ```
    9:14 (and here it is 10:14). So 1h of difference, because the machine is configured in UTC.
    ```

    * What's the name of the hypervisor?
    
    ```
    We are uncertain, but some sources explain we use a modified Xen, and others explain we use a Nitro Hypervisor.
    ```

    * How much free space does the disk have?
    
    ```
    10GB
    ```


* Try to ping the instance ssh srv from your local machine. What do you see?
  Explain. Change the configuration to make it work. Ping the
  instance, record 5 round-trip times.

```
At first, the ping does nothing as the DMZ only accepts connection from port 22 (SSH). If we wanted to ping it, we would need to allow connection from the port used for pings. We believe that we do not have access to those resources and cannot change it as it would change it for everyone.

```

* Determine the IP address seen by the operating system in the EC2
  instance by running the `ifconfig` command. What type of address
  is it? Compare it to the address displayed by the ping command
  earlier. How do you explain that you can successfully communicate
  with the machine?

```
It's a private address (10.x.x.x) whereas the ping done earlier was done using a public IP address. It shouldn't be accessible but as we first connect to the ssh server (that has a public IP address), and then navigate inside the subnet with this private IP address.
```
