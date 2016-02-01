#!/bin/bash
/usr/bin/mysqld_safe &
sleep 5
mysql -u root -e "CREATE DATABASE fb"
mysql -u root fb < /var/www/html/includes/data/create_tables.sql
mysql -u root fb < /var/www/html/includes/data/countries.sql