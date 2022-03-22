#!/usr/bin/env bash

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

device_name=`cat /proc/mdstat | grep -A 1 ^md| grep md | awk -F: '{print $1}'`
a=1
for i in $device_name;do
        device["$a"]="$i"
        a=` expr $a + 1 `
done
c=1
for((b=1;b<$a;b++));do
        state_raid["$c"]=`cat /proc/mdstat | grep -A 1 ^${device[$b]} | grep -v blocks| awk '{print $3}'`
        usage_raid["$c"]=`cat /proc/mdstat | grep -A 1 ^${device[$b]} | tail -1 | awk '{print ($(NF-1))}'| tr -d [] | awk -F/ '{printf ($2)}'`
        total_raid["$c"]=`cat /proc/mdstat | grep -A 1 ^${device[$b]} | tail -1 | awk '{print ($(NF-1))}'| tr -d [] | awk -F/ '{printf ($1)}'`
        c=` expr $c + 1 `
done
STATE1=1
for((b=1;b<$c;b++));do
        if [ "${state_raid["$b"]}" == "active" ];then
                if [ ${usage_raid["$b"]} = ${total_raid["$b"]} ]; then
                        echo "OK:  ${device["$b"]} [${usage_raid["$b"]}/${total_raid["$b"]}]"
                        STATE1=` expr $STATE1 + 1 `
                else
                        echo "FAIL:  ${device["$b"]}: [${usage_raid["$b"]}/${total_raid["$b"]}]"
                fi
        else
        echo "FAIL: ${device["$b"]} is inacvice."
        fi
done

if [ $STATE1 = $c ]; then
           exit $STATE_OK
    else
          exit $STATE_CRITICAL
fi
