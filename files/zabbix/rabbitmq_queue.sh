#!/bin/bash

log_file='/tmp/rabbitmq_queue.log'

len=`sudo /usr/sbin/rabbitmqctl list_queues | grep -vE "Listing queues|.done." | awk '{s+=$2} END {print s}'`
echo $len

if [ $len -gt $1 ]
then
        echo "[ "$(date) "] Treshold $1 was exceeded: " $len >> $log_file
fi

