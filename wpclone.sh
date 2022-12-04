#!/bin/bash

#####################################
# Author: Robbie Powell
# Version: v1.0.0
# Date: 04-12-22
# Description: This script clones Wordpress site to another domain .
# Usage: wpclone <Source> <Destiantion>
#####################################
# Variables ##############
#$1 Source domain
#$2 Destination domain
sdir=awk -F"[:= ]" '/$1/{print $11}' /etc/userdatadomains | column -t | head -n1
ddir=awk -F"[:= ]" '/$2/{print $11}' /etc/userdatadomains | column -t | head -n1
####################################


echo "==================================================="
echo "Clone WordPress Script"
echo "==================================================="

#check source is wordpress site
#checks for wp-config file
if  test -f "$1"; then
        echo "Wordpress site present at source $1"
        else
echo "Source does not appear to be a Wordpress install"

fi

#check destination is empty

if [ -d "$2" ]
then
	if [ "$(ls -A $2)" ]; then
     echo "Take action $DIR is not Empty"
     exit
	else
    echo "$DIR is Empty"
	fi
  else
	echo "Directory $DIR not found."
fi

#copy files from source domain to destination domain

cp $sdir $ddir


#prompt to enter destination db and db_user update destination wp-config
read db_name
read db_user
read db_user_pw
#dump db (check source config file for details) copy source db to destination


#search and replace on destination site from $1 to $2 will need to run command as user
 wp search-replace \"$1\" \"$2\" --all-tables --precise;\