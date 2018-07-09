#!/bin/bash
NOTRUNPOD=`kubectl -n wisecloud-controller get pod | grep -v NAME| grep -v Running`; if [ `echo "$NOTRUNPOD" | grep -v '^$' | wc -l` -eq 0 ];then echo "OK";else echo "$NOTRUNPOD";fi;
