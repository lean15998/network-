#!/bin/bash

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

all_devices=`mdadm --detail --scan | awk '{print $2}' | wc -l`
for((b=1;b<=$all_devices;b++));do
        array[$b]=$(mdadm --detail --scan | awk '{print $2}' | sed -n ${b}p)
       # echo ${array[$b]}
done
a=0
active_devices=0
for((b=1;b<=$all_devices;b++));do
        state=`mdadm --detail ${array[$b]} | grep "State :" | awk '{print $3$4$5$6$7}'`
        if [ "$state" == "clean" ] || [ "$state" == "active" ];then
                active_devices=` expr $active_devices + 1 `
        else
                inactive_devices[$a]=${array[$b]}
                state_fail[$a]=$state
                a=` expr $a + 1 `
        fi
done
if [ "$all_devices" != 0 ];then
        if [ "$active_devices" == "$all_devices" ];then
                echo "OK: all devices is active"
                exit $STATE_OK
        else
                for((b=0;b<$a;b++));do
                echo "CRITICAL: Following devices:${inactive_devices[$b]}, state=${state_fail[$b]}"
                done
        fi
else
        echo "UNKNOWN: can't show all devices"
        exit $STATE_UNKNOWN
fi
exit $STATE_CRITICAL
