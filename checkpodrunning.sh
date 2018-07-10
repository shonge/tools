#!/bin/bash
#对接zabbix ssh.run item 获取ns下pod状态 做非running pod统计，输出 OK 或 具体pod名称
#By Song
NOTRUNPOD=`kubectl -n wisecloud-controller get pod | grep -v NAME| grep -v Running`;
if [ ! -n "$NOTRUNPOD" ];then 
echo "OK";
else echo "$NOTRUNPOD";
fi
