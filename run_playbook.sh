#!/bin/sh

REPORT_HOST=$1
REPORT_HOST_PORT=1022
REPORT_PORT=10000
PLAYBOOK=$2
GROUP=$3

ssh ${REPORT_HOST} -p ${REPORT_HOST_PORT} 'ncat --ssl --listen $(ip -j -4 -br addr show eth0 | jq -r .[0].addr_info[0].local) 10000' &
ansible-playbook playbook.yml -i inventory --limit ${GROUP} -e report_host=${REPORT_HOST} -e playbook_filename=${PLAYBOOK}
