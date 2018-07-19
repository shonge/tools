#!/bin/bash
harbor_endpoint=localhost
harbor_username=admin
harbor_password=password
harbor_schema=http
KEEP_TAGS_NUM=3
PROJECT=`curl -ksS -u ${harbor_username}:${harbor_password} -X GET -H "Content-Type: application/json" ${harbor_schema}://${harbor_endpoint}/api/projects`

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
  TAGS=`curl -ksS -u ${harbor_username}:${harbor_password} -X GET -H "Content-Type: application/json" ${harbor_schema}://${harbor_endpoint}/api/repositories/${r}/tags`
  DEL_TAGS=`echo ${TAGS} | jq .[].name -r | sort -rn| awk 'NR>'${KEEP_TAGS_NUM}' {print}'`
  if [ -z "${DEL_TAGS}" ]
  then
    echo "${harbor_endpoint}/${r}  tags are less than ${KEEP_TAGS_NUM} , nothing to clear."
  else
    echo ${harbor_endpoint}/${r}/ ${DEL_TAGS}
      for t in ${DEL_TAGS};do
          echo ${harbor_endpoint}
