## Migrate from MySQL to PostgreSQL

### Install `pgloader`

One of the prerequisites is having [`pgloader`](https://github.com/dimitri/pgloader) installed on your machine.

#### M1

```bash
# software update
softwareupdate --all --install --force

sudo rm -rf /Library/Developer/CommandLineTools

sudo xcode-select --install

# install rosetta terminal
softwareupdate --install-rosetta --agree-to-license

# install or upgrade openssl
brew install openssl
sudo ln -s /opt/homebrew/Cellar/openssl@3/<openssl version>/lib/libcrypto.dylib /usr/local/lib/libcrypto.dylib
sudo ln -s /opt/homebrew/Cellar/openssl@3/<openssl version>/lib/libssl.dylib /usr/local/lib/libssl.dylib

# install pgloader
cd /path/to/pgloader
make pgloader
./build/bin/pgloader --help
```

#### Ubuntu

```bash
#/bin/bash

sudo su
apt update -y
apt install sbcl unzip libsqlite3-dev make curl gawk freetds-dev libzip-dev openssl libssl-dev libaio1 libaio-dev

echo "/usr/local/lib64" > /etc/ld.so.conf.d/openssl.conf

wget https://github.com/dimitri/pgloader/archive/refs/tags/v3.6.3.zip -O pgloader.zip
unzip pgloader.zip

cd pgloader-3.6.3
make pgloader
./build/bin/pgloader --version
```

### Things to take care

You might need to validate that the following are migrated successfully -

1. Timestamps
2. Sequences
3. Triggers
   The above points are not necessarily always at fault, this is something I have experienced sometimes

## RDS Database Backup

> Backs up all databases in a single RDS instance & save them to S3

#### Use Case

RDS provides [Automated Backups](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithAutomatedBackups.html) to backup the entire RDS instance. However, it works by taking a snapshot of the underlying EBS volumes.

Example - You have 3 databases on a single RDS & u want to restore only one of the database and not the others. Then an automated backup will store the state of all the databases inside it. 
Suppose you wish to restore just one of the database and not the others using one of the stored backups. This wouldn't be possible, as restoring from the generated artifact of an automated backup, restores all the databases & not just a selective one. In such a case, we can periodically take backups of a single database & store it to S3. When we need to restore a particular database, we simply restore it from the database specific backup without affecting other databases.

> Basically, we are logically separating each databases & backing them up separately, instead of all databases in a single snapshot

> Assumption - There exists a user that has `connect` privilege to all the databases. Usually the default `postgres` has access to all databases

## Postgres Database Migration

> Migrates a postgres database from the source machine to destination machine

## Change Ownership
This folder contains scripts to change the ownership of different database objects -

1. Schemas
2. Tables
3. Seqeuences
4. Triggers

For each of the above database objects, the scripts generate a set of alter statements. Run these alter statements in a separate transaction.