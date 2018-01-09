#!/bin/bash

set -eo pipefail

export PRESTO_NODE_ID=NODE_ID

# apply template
for template in $(ls ${PRESTO_CONF_DIR}/*.mustache)
do
    conf_file=${template%.mustache}
    cat ${conf_file}.mustache | ./mustache.sh > ${conf_file}
done

# apply template
for template in $(ls ${PRESTO_CONF_DIR}/catalog/*.mustache)
do
    conf_file=${template%.mustache}
    cat ${conf_file}.mustache | ./mustache.sh > ${conf_file}
done

cp ${PRESTO_CONF_DIR}/${ROLE}.properties ${PRESTO_CONF_DIR}/config.properties
rm /var/app/presto/etc/*.mustache
rm /var/app/presto/etc/coordinator.properties /var/app/presto/etc/worker.properties
rm /var/app/presto/etc/catalog/*.mustache

echo "${PRIVATE_IP} ${AWS_HOSTNAME}" /etc/hosts

/var/app/presto/bin/launcher run
