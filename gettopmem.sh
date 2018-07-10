#!/bin/bash
top -n 1 -b > ./top.txt

TABLESPACE=`tail -n +8 ./top.txt|awk '{a[$NF]+=$6}END{for(k in a)print a[k]/1024,k}'|sort -gr|head -10|cut -d" " -f2`
    COUNT=`echo "$TABLESPACE" |wc -l`
INDEX=0
echo '{"data":['
echo "$TABLESPACE" | while read LINE; do
    echo -n '{"{#PROCESSNAME}":"'$LINE'"}'
    INDEX=`expr $INDEX + 1`
    if [ $INDEX -lt $COUNT ]; then
        echo ','
    fi
done
echo ']}'
