#!/usr/bin/env bash

sudo apt-get install -y python-software-properties
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update

sudo apt-get install -y postgresql-9.3 postgresql-contrib postgresql-dev
sudo apt-get install -y postgis postgresql-9.3-postgis-2.1 postgresql-9.3-postgis-2.1-scripts postgresql-9.3-postgis-scripts

            # PG setup. From:
##### https://github.com/jackdb/pg-app-dev-vm/blob/master/Vagrant-setup/bootstrap.sh
# Edit postgresql.conf to change listen address to '*':
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "/etc/postgresql/9.3/main/postgresql.conf"
# Append to pg_hba.conf to add password auth:
sudo echo "host all all all md5" >> "/etc/postgresql/9.3/main/pg_hba.conf"

# Restart so that all new config is loaded:
sudo service postgresql restart

# Create `kademo` user and create DB
cat << EOF | su - postgres -c psql
-- Create the database user:
CREATE USER kademo WITH PASSWORD 'kademo';

-- Create the database:
CREATE DATABASE bag WITH OWNER=kademo
                                 LC_COLLATE='en_US.utf8'
                                 LC_CTYPE='en_US.utf8'
                                 ENCODING='UTF8'
                                 TEMPLATE=template0;
EOF

# Enable postgis for `bag`
sudo -u postgres psql -d bag -c "CREATE EXTENSION postgis;"
sudo -u postgres psql -d bag -c "CREATE EXTENSION postgis_topology;"

echo "VM provisioned. Starting the download of the DB dump..."
# Download dump
cd /vagrant
if [ ! -f dump.backup ]; then
    #wget http://data.nlextract.nl/bag/postgis/bag-amstelveen.backup -O dump.backup
    # wget http://data.nlextract.nl/bag/postgis/bag-2015_01_07.backup -O dump.backup
    wget http://data.nlextract.nl/bag/postgis/bag-2015_04_23.backup -O dumb.backup
fi
echo "DB Downloaded. Starting restoration..."
# Restore DB
sudo -u postgres pg_restore -d bag dump.backup

