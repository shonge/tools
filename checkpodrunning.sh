#!/bin/bash
NOTRUNPOD=`kubectl -n wisecloud-controller get pod | grep -v NAME| grep -v Running`;if [ ! -n "$NOTRUNPOD" ];then echo "OK";else echo "$NOTRUNPOD";fi
