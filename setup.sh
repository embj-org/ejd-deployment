#!/bin/bash

set -e
DB_CONTAINER_NAME=postgresql

echo "Setting up environment configuration..."
echo

read -p "Database username: " DB_USER
read -s -p "Database password: " DB_PASSWORD
echo
read -p "Database name: " DB_NAME
read -s -p "PostgreSQL admin password: " DB_POSTGRES_PASSWORD
echo

JWT_SECRET=$(openssl rand -hex 32)

sed -i "s/POSTGRESQL_USERNAME=.*/POSTGRESQL_USERNAME=$DB_USER/" postgresql/postgresql.env
sed -i "s/POSTGRESQL_PASSWORD=.*/POSTGRESQL_PASSWORD=$DB_PASSWORD/" postgresql/postgresql.env
sed -i "s/POSTGRESQL_DATABASE=.*/POSTGRESQL_DATABASE=$DB_NAME/" postgresql/postgresql.env
sed -i "s/POSTGRESQL_POSTGRES_PASSWORD=.*/POSTGRESQL_POSTGRES_PASSWORD=$DB_POSTGRES_PASSWORD/" postgresql/postgresql.env

sed -i "s|DATABASE_URL=.*|DATABASE_URL=postgres://$DB_USER:$DB_PASSWORD@$DB_CONTAINER_NAME/$DB_NAME|" ejd/ejd.env
sed -i "s/JWT_SECRET=.*/JWT_SECRET=$JWT_SECRET/" ejd/ejd.env

echo "Configuration complete!"
