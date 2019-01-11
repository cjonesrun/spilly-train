#!/bin/bash
#FreeDNS updater script

set -x
. ../freedns.apikey

echo $KEY
sudo wget -O - http://sync.afraid.org/u/$KEY/ >> /var/log/freedns_sarcastico_net.log 2>&1 &

sudo wget -O /var/log/freedns_update.log - http://sync.afraid.org/u/$KEY/
