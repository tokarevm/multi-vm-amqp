#!/bin/bash

WORK_APP=/opt/myapp
WORKER_SLEEP_TIMEOUT=60
GEN_DATA_TIMEOUT=30

cd $WORK_APP

for (( i=0; i<10; i++ ))
do
    rndnum=$(( ( RANDOM % $WORKER_SLEEP_TIMEOUT )  + 1 ))
    java -classpath .:amqp-client-4.0.2.jar:slf4j-api-1.7.21.jar:slf4j-simple-1.7.22.jar Send $rndnum
    rndnum=$(( ( RANDOM % $GEN_DATA_TIMEOUT )  + 1 ))
    echo "Sleep $rndnum seconds"
    sleep $rndnum
done

