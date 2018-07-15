#!/bin/bash
function docker_login(){
    docker login -u=$registry_user_name -p=$registry_password -e=$registry_email $registry_url
    if [ $? -ne 0 ]; then
        echo "[NOTE]: docker login $registry_url failed!"
        return 2
    fi
}

registry_url=$1
registry_project=$2
registry_user_name=$3
registry_password=$4
registry_email=$5


function update_imgs(){
echo > ./pull.list
while read line
    do
        img=`echo ${line} |awk -F '[/ ]+' '{print $3}'`
        name=`echo ${line} |awk -F '[/ :]+' '{print $3}'`
#       echo ${rurl}/${img}
#       echo ${lurl}/${name}
    docker pull ${rurl}/${img}
    if [[ ${line} =~ ${version} ]] 
    then 
        docker tag ${rurl}/${img} ${lurl}/${name}:v1.4.9
        docker push ${lurl}/${name}:v1.4.9
        echo "docker pull ${lurl}/${name}:v1.4.9" >> ./pull.list
    else
        docker tag ${rurl}/${img} ${lurl}/${img}
        docker push ${lurl}/${img}
        echo "docker pull ${lurl}/${img}" >> ./pull.list
    fi
    done < imgs.list
}


version="v1.4.9"
rurl="registry.cn-hangzhou.aliyuncs.com/wise2c-prd"
lurl="192.168.1.9/library"

docker_login
update_imgs
