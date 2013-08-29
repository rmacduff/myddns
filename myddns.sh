#!/bin/bash

# A script that maintains a dynamic DNS record.
#
# Configurable parameters are stored in ~/.myddns/myddns.conf:
#
# SERVER
# ZONE
# RECORD
# TYPE
# A
#
# Inspired by:
# http://nexus.zteo.com/blog/your-own-dynamic-dns-in-3-steps/
#

# Exit on any errors
set -e

# A site that returns nothing but your IP
IP_URL=http://icanhazip.com/

# Some script configurables
MYDDNS_DIR=${HOME}/.myddns
LOG_FILE=${MYDDNS_DIR}/myddns.log
MYDDNS_CONFIG=${MYDDNS_DIR}/myddns.conf
DEBUG="no"

[[ ! -d $MYDDNS_DIR ]] && { echo "myddns directory $MYDDNS_DIR does not exist"; exit 1; }
[[ ! -r $MYDDNS_CONFIG ]] && { echo "myddns config $MYDDNS_CONFIG does not exist"; exit 1; }


# Details related to your record
. $MYDDNS_CONFIG
KEY_LOC="${MYDDNS_DIR}/${KEY_NAME}"

# Retrieve public IP from designated provider
curr_ip=$( curl -s $IP_URL )

# Retrieve IP from DNS record
old_ip=$( host -t a $RECORD | cut -d' ' -f4 )

# Exit if IP has not changed 
if [[ ${curr_ip// /} == ${old_ip// /} ]]
then
	if [[ $DEBUG = "yes" ]]
	then
		echo "No change to IP: $curr_ip"
	fi
	exit 0
fi

# A date stamp for the log file
echo ==== $( date "+%F %T" ) ==== &>> $LOG_FILE

# Update record
cat <<EOF | /usr/bin/nsupdate -k $KEY_LOC 2>&1 | tee -a $LOG_FILE
server $SERVER
zone $ZONE
update delete $RECORD $TYPE
update add $RECORD $TTL $TYPE $curr_ip
show
send
EOF

exit 0
