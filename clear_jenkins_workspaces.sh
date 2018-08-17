#!/bin/bash
#删除3小时之前的构建路径
find /root/.jenkins/workspaces/* -maxdepth 0 -type d -mmin +180 | xargs -I {} rm -rf {}
