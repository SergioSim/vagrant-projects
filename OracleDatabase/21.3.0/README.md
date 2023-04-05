# oracle-21c-vagrant

This Vagrant project builds an Oracle Linux 8 virtual machine.

The virtual machine is provisioned with scripts from the `scripts` directory,
configuration files from the `config` directory and other installation files that need to
be placed in the same directory as this `README.md`.

The scripts install the following software:

- Oracle Database 21.0.3
- MySQL 8.0.26 (or higher)
- Apache Hadoop 3.3.4
- Apache Spark 3.3.2
- Oracle NoSQL Database Enterprise Edition (KVStore) 22.3.32 with examples 22.1.16
- Apache Hive 3.1.3
- MongoDB 3.4
- JDK 8
- Python 3.9
- R 4.2.2 (or higher)
- Editors: nano and vim

## Build the Virtual Machine

This section explains how to build this virtual machine on your computer.

### Prerequisites

#### Hardware

To build and run this project it is required that your computer `supports virtualization`, have `30G` of available disk space and `5G` of available RAM.

#### Software

1. Install a Git client (for example [git SCM](https://git-scm.com/download/win)).
2. Install [Oracle VM VirtualBox 6.1](https://www.virtualbox.org/wiki/Download_Old_Builds_6_1) (Vagrant doesn't support VirtualBox version 7 at the time of writing).
3. Install the [VirtualBox Extension Pack](https://download.virtualbox.org/virtualbox/6.1.40/Oracle_VM_VirtualBox_Extension_Pack-6.1.40.vbox-extpack).
4. Install [Vagrant](https://www.vagrantup.com/) and (optionally) the [vagrant-env](https://github.com/gosuri/vagrant-env) plugin.

### Setup installation files

1. Clone this repository's staging branch.
  ```bash
  git clone -b staging https://github.com/SergioSim/vagrant-projects.git
  ```
2. Download the `Oracle Database 21.3.0` installation zip file (`LINUX.X64_213000_db_home.zip`) from OTN (the first time only) and place it in the `vagrant-projects/OracleDatabase/21.3.0` directory:
[http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html)
3. Download the `Oracle NoSQL Database Enterprise Edition 22.3.32` installation zip file (`V1034077-01.zip`) and examples (`V1020129-01.zip`) from OTN (the first time only) and place it in the `vagrant-projects/OracleDatabase/21.3.0` directory:
[https://www.oracle.com/database/technologies/nosql-database-server-downloads.html](https://www.oracle.com/database/technologies/nosql-database-server-downloads.html)

> Note: **Do not** unzip the installation files. Double check that the installation
> filenames match : `LINUX.X64_213000_db_home.zip`, `V1034077-01.zip` and
> `V1020129-01.zip`.

### Build and start the virtual machine

1. Open a terminal and change into the `vagrant-projects/OracleDatabase/21.3.0` directory.
  ```bash
  $ cd vagrant-projects/OracleDatabase/21.3.0
  ```
2. Run the `vagrant up` command in your terminal.
  ```bash
  $ vagrant up
  ```

- The first time you run this it will provision everything and may take a while. Ensure you have a **good internet connection** as the scripts will update the Virtual Machine via `yum`.
- The installation can be customized, if desired (see [Configuration](#configuration)).
- It might be useful to **keep the installation traces** (they can provide debugging information if something goes wrong or other useful information that might be needed afterwards, for example, the auto-generated Oracle Database passwords)

## Interact with the virtual machine using vagrant

Here we describe some common commands to interact with the virtual machine using vagrant.

To start interacting with the virtual machine, open a terminal and change into the `vagrant-projects/OracleDatabase/21.3.0` directory.
  ```bash
  $ cd vagrant-projects/OracleDatabase/21.3.0
  ```

### Get virtual machine status information

To get a short report about the current state of the virtual machine, you can use the following command:

```bash
$ vagrant status
```

The command should output something like:

```
Current machine states:

oracle-21c-vagrant        running (virtualbox)
```

### Stop the virtual machine

To stop the virtual machine you can use the following command:

```bash
$ vagrant halt
```

### Remove the virtual machine

To remove the virtual machine completely you can use the following commands:

```bash
$ vagrant destroy
$ vagrant box remove oraclelinux/8
```

### Start the virtual machine

To start or restart the virtual machine you can use the following command:

```bash
$ vagrant up
```

> Note: Provisioning scripts **only run once** at the very first start.

### Connect to the virtual machine via SSH

To open a `SSH` connection with the virtual machine you can use the following command:

```bash
$ vagrant ssh
```

The command should provide you with a bash prompt for the `vagrant` user inside the virtual machine (without requiring a password):

```
[vagrant@oracle-21c-vagrant ~]$
```

> Note: the `vagrant` user has `sudo` privileges. If you would like to switch to the `root` user you can run the `sudo su -` command.

## Common usage examples

Once you have [connected to the virtual machine via ssh](#connect-to-the-virtual-machine-via-ssh) you can try out to run some of the common usage examples described in [EXAMPLES.md](./EXAMPLES.md)

## Troubleshooting

If some components of this virtual machine stop working it is possible to re-install
them by re-running their corresponding provisioning scripts.

- To reinstall prerequisites (JDK 8/vim/nano) and setup `.bashrc` and `.bash_profile`:
  ```bash
  vagrant provision --provision-with scripts/02_prerequisites.sh
  ```
- To reinstall Hadoop:
  ```bash
  vagrant provision --provision-with scripts/03_install_hadoop.sh
  ```
- To reinstall Spark
  ```bash
  vagrant provision --provision-with scripts/04_install_spark.sh
  ```
- To reinstall KVStore
  ```bash
  vagrant provision --provision-with scripts/05_install_kvstore.sh
  ```
- To reinstall Hive
  ```bash
  vagrant provision --provision-with scripts/06_install_hive.sh
  ```
- To reinstall MongoDB
  ```bash
  vagrant provision --provision-with scripts/07_install_mongodb.sh
  ```
- To reinstall R
  ```bash
  vagrant provision --provision-with scripts/08_install_R.sh
  ```

## Optional provisioners

Some optional/utility provisioning scripts are available.

- To update all changes made in the `config` directory
  (recopy all files to their corresponding destination).
  ```bash
  vagrant provision --provision-with scripts/update_config.sh
  ```
- To downgrade MongoDB version to 3.4
  > Warning: This command removes all previous data stored on MongoDB.
  ```bash
  vagrant provision --provision-with scripts/99_downgrade_mongodb.sh
  ```
- To enable MongoDB authentication
  > Note: It uses the `VM_MONGO_ADMIN_USERNAME` and `VM_MONGO_ADMIN_PASSWORD` environment
  > variables to create the MongoDB administrative user.
  ```bash
  vagrant provision --provision-with 99_enable_mongodb_authentication.sh
  ```
- To disable MongoDB authentication
  > Note: It doesn't remove the MongoDB administrative user.
  ```bash
  vagrant provision --provision-with 99_disable_mongodb_authentication.sh
  ```
- To install Kafka
  > Note: Kafka consumes 1.5 G of additional RAM, consider increasing the VM_MEMORY up
  > to 6-7G in the Vagrantfile or stop unused services to save memory.

  > Note: running the `02_prerequisites.sh` script is only required if you have
  > installed the VM prior to the Kafka installation addition.
  ```
  vagrant provision --provision-with scripts/02_prerequisites.sh
  vagrant provision --provision-with scripts/99_install_kafka.sh
  ```
- To install Sqoop
  > Note: running the `02_prerequisites.sh` script is only required if you have
  > installed the VM prior to the Sqoop installation addition.
  ```
  vagrant provision --provision-with scripts/02_prerequisites.sh
  vagrant provision --provision-with scripts/99_install_sqoop.sh
  ```
  > Note: Sqoop doesn't work well with Yarn in "local" mode. It is required to change
  > Yarn's deployment mode to "pseudo-distributed" by editing
  > `/usr/local/hadoop/etc/hadoop/mapred-site.xml` and setting the value of the
  > property: `mapreduce.framework.name` to `yarn`:
  > ```
  > <property>
  >     <name>mapreduce.framework.name</name>
  >     <value>yarn</value>
  >     <description>
  >       Local mode runs faster in a single node setup for simple tasks.
  >       To use pseudo-distributed mode set the value to "yarn".
  >     </description>
  > </property>
  > ```
  > For the changes to apply - restart Yarn:
  > ```
  > stop-yarn.sh
  > start-yarn.sh
  > ```
- To install Jupyter Notebook
  ```
  vagrant provision --provision-with scripts/99_install_jupyter.sh
  ```
  To start Jupyter Notebook (inside the VM):
  ```
  cd /vagrant
  jupyter notebook --ip=0.0.0.0
  ```


## Connecting to Oracle

The default database connection parameters are:

* Hostname: `localhost`
* Port: `1521`
* SID: `ORCLCDB`
* PDB: `ORCLPDB1`
* EM Express port: `5500`
* Database passwords are auto-generated and printed on install

These parameters can be customized, if desired (see [Configuration](#configuration)).

## Resetting password

You can reset the password of the Oracle database accounts (SYS, SYSTEM and PDBADMIN only) by switching to the oracle user (`sudo su - oracle`), then executing `/home/oracle/setPassword.sh <Your new password>`.

## Running scripts after setup

You can have the installer run scripts after setup by putting them in the `userscripts` directory below the directory where you have this file checked out. Any shell (`.sh`) or SQL (`.sql`) scripts you put in the `userscripts` directory will be executed by the installer after the database is set up and started. Only shell and SQL scripts will be executed; all other files will be ignored. These scripts are completely optional.

Shell scripts will be executed as root. SQL scripts will be executed as SYS. SQL scripts will run against the CDB, not the PDB, unless you include an `ALTER SESSION SET CONTAINER = <pdbname>` statement in the script.

To run scripts in a specific order, prefix the file names with a number, e.g., `01_shellscript.sh`, `02_tablespaces.sql`, `03_shellscript2.sh`, etc.

## Configuration

The `Vagrantfile` can be used _as-is_, without any additional configuration. However, there are several parameters you can set to tailor the installation to your needs.

### How to configure

There are three ways to set parameters:

1. Update the `Vagrantfile`. This is straightforward; the downside is that you will lose changes when you update this repository.
2. Use environment variables. It might be difficult to remember the parameters used when the VM was instantiated.
3. Use the `.env`/`.env.local` files (requires
[vagrant-env](https://github.com/gosuri/vagrant-env) plugin). You can configure your installation by editing the `.env` file, but `.env` will be overwritten on updates, so it's better to make a copy of `.env` called `.env.local`, then make changes in `.env.local`. The `.env.local` file won't be overwritten when you update this repository and it won't mark your Git tree as changed (you won't accidentally commit your local configuration!).

Parameters are considered in the following order (first one wins):

1. Environment variables
2. `.env.local` (if it exists and the  [vagrant-env](https://github.com/gosuri/vagrant-env) plugin is installed)
3. `.env` (if the [vagrant-env](https://github.com/gosuri/vagrant-env) plugin is installed)
4. `Vagrantfile` definitions

### VM parameters

* `VM_NAME` (default: `oracle-21c-vagrant`): VM name.
* `VM_MEMORY` (default: `5120`): memory for the VM (in MB, 5120 MB = 5 GB).
* `VM_SYSTEM_TIMEZONE` (default: host time zone (if possible)): VM time zone.
  * The system time zone is used by the database for SYSDATE/SYSTIMESTAMP.
  * The guest time zone will be set to the host time zone when the host time zone is a full hour offset from GMT.
  * When the host time zone isn't a full hour offset from GMT (e.g., in India and parts of Australia), the guest time zone will be set to UTC.
  * You can specify a different time zone using a time zone name (e.g., "America/Los_Angeles") or an offset from GMT (e.g., "Etc/GMT-2"). For more information on specifying time zones, see [List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

### Oracle Database parameters

* `VM_ORACLE_BASE` (default: `/opt/oracle/`): Oracle base directory.
* `VM_ORACLE_HOME` (default: `/opt/oracle/product/21c/dbhome_1`): Oracle home directory.
* `VM_ORACLE_SID` (default: `ORCLCDB`): Oracle SID.
* `VM_ORACLE_PDB` (default: `ORCLPDB1`): PDB name.
* `VM_ORACLE_CHARACTERSET` (default: `AL32UTF8`): database character set.
* `VM_ORACLE_EDITION` (default: `EE`): Oracle Database edition. Either `EE` for Enterprise Edition or `SE2` for Standard Edition 2.
* `VM_LISTENER_PORT` (default: `1521`): Listener port.
* `VM_EM_EXPRESS_PORT` (default: `5500`): EM Express port.
* `VM_ORACLE_PWD` (default: automatically generated): Oracle Database password for the SYS, SYSTEM and PDBADMIN accounts.

## Optional plugins

When installed, this Vagrant project will make use of the following third party Vagrant plugins:

* [vagrant-env](https://github.com/gosuri/vagrant-env): loads environment
variables from .env files;
* [vagrant-proxyconf](https://github.com/tmatilai/vagrant-proxyconf): set
proxies in the guest VM if you need to access the Internet through a proxy. See
the plugin documentation for configuration.

To install Vagrant plugins run:

```shell
vagrant plugin install <name>...
```

## Other info

* If you need to, you can connect to the virtual machine via `vagrant ssh`.
* You can `sudo su - oracle` to switch to the oracle user.
* On the guest OS, the directory `/vagrant` is a shared folder and maps to wherever you have this file checked out.
