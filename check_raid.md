#!/bin/bash

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

all_devices=`mdadm --detail --scan | awk '{print $2}' | wc -l`
device_name=`cat /proc/mdstat | grep -A 1 ^md| grep md | awk -F: '{print $1}'`
d=1
for i in $device_name;do
        device["$d"]="$i"
        d=` expr $d + 1 `
done
for((b=1;b<=$all_devices;b++));do
        array[$b]="/dev/${device[$b]}"
done
c=1
for((b=1;b<$d;b++));do
        state_raid["$c"]=`cat /proc/mdstat | grep -A 1 ^${device[$b]} | grep -v blocks| awk '{print $3}'`
        usage_raid["$c"]=`cat /proc/mdstat | grep -A 1 ^${device[$b]} | tail -1 | awk '{print ($(NF-1))}'| tr -d [] | awk -F/ '{printf ($2)}'`
        total_raid["$c"]=`cat /proc/mdstat | grep -A 1 ^${device[$b]} | tail -1 | awk '{print ($(NF-1))}'| tr -d [] | awk -F/ '{printf ($1)}'`
        c=` expr $c + 1 `
done
a=1
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
i=1
if [ "$all_devices" != 0 ];then
        if [ "$active_devices" == "$all_devices" ];then
                echo "OK: all devices is active"
                exit $STATE_OK
        else
                for((b=1;b<=$c;b++));do
                if [ "${state_raid["$b"]}" == "active" ];then
                        if [ ${usage_raid["$b"]} = ${total_raid["$b"]} ]; then
                                STATE1=` expr $STATE1 + 1 `
                        else
                                fail[$i]="[${usage_raid["$b"]}/${total_raid["$b"]}]"
                                i=` expr $i + 1 `
                        fi
                fi
                done
                for((b=1;b<$a;b++));do
                        echo "CRITICAL: Following devices:${inactive_devices[$b]}, state=${state_fail[$b]}, ${fail[$b]}"
                        done
        fi
else
        echo "UNKNOWN: can't show all devices"
        exit $STATE_UNKNOWN
fi
exit $STATE_CRITICAL

