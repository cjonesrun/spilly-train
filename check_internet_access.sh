#!/bin/bash

# checks internet from inside

INTERNET_STATUS="UNKNOWN"
TIMESTAMP=`date +%s`
LOG="/var/log/check-internet-up-down.log"

while [ 1 ]
 do
    ping -c 1 -W 3 208.67.220.220 > /dev/null 2>&1
    if [ $? -eq 0 ] ; then
        if [ "$INTERNET_STATUS" != "UP" ]; then
	    #DIFF=$((`date +%s`-$TIMESTAMP))
	    #echo "DIFF $DIFF"
            echo "UP,`date +%Y-%m-%dT%H:%M:%S%Z`,$((`date +%s`-$TIMESTAMP))" | tee -a $LOG
            INTERNET_STATUS="UP"
	    TIMESTAMP=`date +%s`
#	else
#	    echo "UP STILL,`date +%Y-%m-%dT%H:%M:%S%Z`,$((`date +%s`-$TIMESTAMP))" | tee -a $LOG
        fi
    else
        if [ "$INTERNET_STATUS" = "UP" ]; then
            echo "DOWN, `date +%Y-%m-%dT%H:%M:%S%Z`,$((`date +%s`-$TIMESTAMP))" | tee -a $LOG
            INTERNET_STATUS="DOWN"
	    TIMESTAMP=`date +%s`
#	else
#	    echo "DOWN STILL,`date +%Y-%m-%dT%H:%M:%S%Z`,$((`date +%s`-$TIMESTAMP))" | tee -a $LOG
        fi
    fi
    sleep 1
 done;
