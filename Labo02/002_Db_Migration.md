# Database migration

In this task you will migrate the Drupal database to the new RDS database instance.

![Schema](./img/CLD_AWS_INFA.PNG)

## Task 01 - Securing current Drupal data

### [Get Bitnami MariaDb user's password](https://docs.bitnami.com/aws/faq/get-started/find-credentials/)

```bash
[INPUT]
cat ~/bitnami_credentials

[OUTPUT]
Welcome to the Bitnami package for Drupal

******************************************************************************
The default username and password is 'user' and 'xxx'.
******************************************************************************

You can also use this password to access the databases and any other component the stack includes.

Please refer to https://docs.bitnami.com/ for more details.

```

### Get Database Name of Drupal

```bash
[INPUT]
mariadb -u root -p

show databases;

[OUTPUT]
+--------------------+
| Database           |
+--------------------+
| bitnami_drupal     |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test               |
+--------------------+
6 rows in set (0.003 sec)
```

### [Dump Drupal DataBases](https://mariadb.com/kb/en/mariadb-dump/)

```bash
[INPUT]
mariadb-dump bitnami_drupal -u root -p > mariadb-dump.sql
[OUTPUT]
# Nothing, redirected to mariadb.dump (sql script)
```

### Create the new Data base on RDS

```sql
[INPUT]
CREATE DATABASE bitnami_drupal;
```

### [Import dump in RDS db-instance](https://mariadb.com/kb/en/restoring-data-from-dump-files/)

Note : you can do this from the Drupal Instance. Do not forget to set the "-h" parameter.

```sql
[INPUT]
mariadb -h dbi-devopsteam04.cshki92s4w5p.eu-west-3.rds.amazonaws.com -u admin -p bitnami_drupal < mariadb-dump.sql

[OUTPUT]
# Nothing
```

### [Get the current Drupal connection string parameters](https://www.drupal.org/docs/8/api/database-api/database-configuration)

```bash
[INPUT]
less /bitnami/drupal/sites/default/settings.php

[OUTPUT]
...
  'username' => 'bn_drupal',
  'password' => '043e3cf4dcc1e346f2c718149a139e7c07f2cec2ac03f8c4446053c39565710b',
...
```

### Replace the current host with the RDS FQDN

```
//settings.php

$databases['default']['default'] = array (
   [...] 
  'host' => 'dbi-devopsteam04.cshki92s4w5p.eu-west-3.rds.amazonaws.com',
   [...] 
);
```

### [Create the Drupal Users on RDS Data base](https://mariadb.com/kb/en/create-user/)

Note : only calls from both private subnets must be approved.
* [By Password](https://mariadb.com/kb/en/create-user/#identified-by-password)
* [Account Name](https://mariadb.com/kb/en/create-user/#account-names)
* [Network Mask](https://cric.grenoble.cnrs.fr/Administrateurs/Outils/CalculMasque/)

```sql
[INPUT]
CREATE USER bn_drupal@'10.0.4.0/255.255.255.240' IDENTIFIED BY '043e3cf4dcc1e346f2c718149a139e7c07f2cec2ac03f8c4446053c39565710b';

GRANT ALL PRIVILEGES ON bitnami_drupal.* TO bn_drupal@'10.0.4.0/255.255.255.240';

//DO NOT FORGET TO FLUSH PRIVILEGES
```

```sql
//validation
[INPUT]
SHOW GRANTS for 'bn_drupal'@'10.0.4.0/255.255.255.240';

[OUTPUT]
+---------------------------------------------------------------------------------------------------------------------------------+
| Grants for bn_drupal@10.0.4.0/255.255.255.240
                                      |
+---------------------------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `bn_drupal`@`10.0.4.0/255.255.255.240` IDENTIFIED BY PASSWORD '*E95F9DF2C7176AE4B7FC0DACE5F0700DBF1ECD94' |
| GRANT ALL PRIVILEGES ON `bitnami_drupal`.* TO `bn_drupal`@`10.0.4.0/255.255.255.240`                                            |
+---------------------------------------------------------------------------------------------------------------------------------+
```

### Validate access (on the drupal instance)

```sql
[INPUT]
mariadb -h dbi-devopsteam04.cshki92s4w5p.eu-west-3.rds.amazonaws.com -u bn_drupal -p 

[INPUT]
show databases;

[OUTPUT]
+--------------------+
| Database           |
+--------------------+
| bitnami_drupal     |
| information_schema |
+--------------------+
2 rows in set (0.001 sec)
```

* Repeat the procedure to enable the instance on subnet 2 to also talk to your RDS instance.
