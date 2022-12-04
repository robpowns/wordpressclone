#! /bin/bash
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
sdir=$(awk -F"[:= ]" '/$1/{print $11}' /etc/userdatadomains | column -t | head -n1)
ddir=$(awk -F"[:= ]" '/$2/{print $11}' /etc/userdatadomains | column -t | head -n1)
duser=$(/scripts/whoowns $2)
####################################


echo "==================================================="
echo "Clone WordPress Script"
echo "==================================================="

#check source is wordpress site
#checks for wp-config file
if  test -f "$1"; then
        echo "Wordpress site present at source $1"
        else
echo "Source does not appear to be a Wordpress install"

fi

#check destination is empty

if [ -d "$2" ]
then
	if [ "$(ls -A "$2")" ]; then
     echo "Take action $ddir is not Empty"
     exit
	else
    echo "$ddir is Empty"
	fi
  else
	echo "Directory $ddir not found."
fi

#copy files from source domain to destination domain

cp "$sdir" "$ddir"


#prompt to enter destination db and db_user update destination wp-config
read -r db_name
read -r db_user
read -r db_user_pw
#dump db (check source config file for details) copy source db to destination
WPDBNAME=$(cat wp-config.php | grep DB_NAME | cut -d \' -f 4)
WPDBUSER=$(cat wp-config.php | grep DB_USER | cut -d \' -f 4)
WPDBPASS=$(cat wp-config.php | grep DB_PASSWORD | cut -d \' -f 4)

mysqldump –u "$WPDBUSER"  –p "$WPDBPASS" "$WPDBNAME" > source.sql
cd "$ddir" || exit
su -H -u duser bash -c 
wp config create --dbname="$db_name"--dbuser="$db_user" --dbpass="$db_user_pw"
exit
cd || exit
#destination
mysql -u dbname="$db_name"  -p db_user_pw "$db_user" < source.sql


#search and replace on destination site from $1 to $2 will need to run command as user
su -H -u $duser bash -c 
cd  "$ddir" wp search-replace "$1" "$2" --all-tables --precise || exit;
exit
cd || exit
curl -l $2
