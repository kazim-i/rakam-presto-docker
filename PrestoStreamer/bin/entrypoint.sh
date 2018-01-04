#!/bin/bash

set -eo pipefail

export PRESTO_NODE_ID=NODE_ID

# apply template
for template in $(ls ${PRESTOST_CONF_DIR}/*.mustache)
do
    conf_file=${template%.mustache}
    cat ${conf_file}.mustache | ./mustache.sh > ${conf_file}
done

rm ${PRESTOST_CONF_DIR}/*.mustache

/var/app/presto-streamer/bin/launcher run
