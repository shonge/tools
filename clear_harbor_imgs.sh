#!/bin/bash
#curl -u "admin:password" -X GET -H "Content-Type: application/json" "http://127.0.0.1/api/projects" > projects.json
#cat projects.json | jq .[].name
#cat projects.json | jq '.[] | select(.name == "testttt")| .project_id'
#curl -u "admin:password" -X GET -H "Content-Type: application/json" "http://127.0.0.1/api/repositories?project_id=12" > repo.json
#curl -ksS -u "admin:password" -X GET -H "Content-Type: application/json" "http://127.0.0.1/api/repositories/testttt/nginx/tags" | jq .[].name -r | sort -rn| awk 'NR>3 {print}'
#curl -ksS -u "admin:password" -X DELETE -w %{http_code} -H "Content-Type: application/json" "http://127.0.0.1/api/repositories/testttt/nginx/tags/v2"

harbor_endpoint=localhost
harbor_username=admin
harbor_password=password
harbor_schema=http
KEEP_TAGs_NUM=3

tag=`curl -ksS -u "admin:password" -X GET -H "Content-Type: application/json" "http://127.0.0.1/api/repositories/testttt/nginx/tags" | jq .[].name -r | sort -rn| awk 'NR>3 {print}'`
#echo ${tag}
#if [ -z ${tag} ]
#then 
#    echo null
#else
#    echo ${tag}
#fi

#echo "curl -ksS -u "admin:password" -X DELETE -w %{http_code} -H "Content-Type: application/json" "http://127.0.0.1/api/repositories/testttt/nginx/tags/${tag}""
#curl -ksS -u "admin:password" -X DELETE -w %{http_code} -H "Content-Type: application/json" "http://127.0.0.1/api/repositories/testttt/nginx/tags/${tag}"

PROJECT=`curl -ksS -u ${harbor_username}:${harbor_password} -X GET -H "Content-Type: application/json" ${harbor_schema}://${harbor_endpoint}/api/projects`

#PROJECT_NUM=`echo ${PROJECT} | jq ". | length"`
#echo ${PROJECT_NUM}
#echo "${PROJECT}"

function read_project(){
while read LINE
do 
PROJECT_ID=`echo ${PROJECT} | jq '.[] | select(.name == "'${LINE}'") | .project_id'`
REPO=`curl -ksS -u ${harbor_username}:${harbor_password} -X GET -H "Content-Type: application/json" ${harbor_schema}://${harbor_endpoint}/api/repositories?project_id=${PROJECT_ID}`
REPO_NAME=`echo ${REPO} | jq .[].name -r`
del_tags
done < projects.list
}

function del_tags(){
for r in ${REPO_NAME};do
#echo $r
TAGS=`curl -ksS -u ${harbor_username}:${harbor_password} -X GET -H "Content-Type: application/json" ${harbor_schema}://${harbor_endpoint}/api/repositories/${r}/tags`
#echo "$TAGS"
DEL_TAGS=`echo ${TAGS} | jq .[].name -r | sort -rn| awk 'NR>'${KEEP_TAGs_NUM}' {print}'`
#echo ${DEL_TAGS}
if [ -z "${DEL_TAGS}" ]
then
    echo "${harbor_endpoint}/${r}  tags are less than ${KEEP_TAGs_NUM} , nothing to clear."
else
    echo ${harbor_endpoint}/${r}/ ${DEL_TAGS}
    for t in ${DEL_TAGS};do
        echo ${harbor_endpoint}/${r}/${t}
        curl -ksS -u ${harbor_username}:${harbor_password} -X DELETE -w %{http_code}"\n" -H "Content-Type: application/json" ${harbor_schema}://${harbor_endpoint}/api/repositories/${r}/tags/${t}
    done
fi
#echo "$DEL_TAGS"
#curl -ksS -u ${harbor_username}:${harbor_password} -X DELETE -w %{http_code} -H "Content-Type: application/json" ${harbor_schema}://${harbor_endpoint}/
done
}


read_project
