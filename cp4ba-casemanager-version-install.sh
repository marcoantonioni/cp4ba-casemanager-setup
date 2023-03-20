#!/bin/bash

CASE_MGR_HOME_FULL_PATH=$1
CASE_MANAGER_VERSION=$2

if [ "${CASE_MGR_HOME_FULL_PATH}" == "" ]; then
  echo "ERROR: env var CASE_MGR_HOME_FULL_PATH not set !"
  exit
fi

if [ "${CASE_MANAGER_VERSION}" == "" ]; then
  echo "ERROR: env var CASE_MANAGER_VERSION not set !"
  exit
fi

if [ -d "${CASE_MGR_HOME_FULL_PATH}" ]; then

  APP_VERSION=$(curl -sk https://raw.githubusercontent.com/IBM/cloud-pak/master/repo/case/ibm-cp-automation/index.yaml | grep "${CASE_MANAGER_VERSION}" -A1 | grep appVersion | sed 's/appVersion: //g' | sed 's/^ *//g')
  if [ "${APP_VERSION}" == "" ]; then
    echo "ERROR: CASE_MANAGER_VERSION [${CASE_MANAGER_VERSION}] doesn't exist !"
    exit
  fi

  echo "Installing case version[${CASE_MANAGER_VERSION}] pak version [${APP_VERSION}] into foder ${CASE_MGR_HOME_FULL_PATH}"
  mkdir -p ${CASE_MGR_HOME_FULL_PATH}
  cd ${CASE_MGR_HOME_FULL_PATH}
  curl -sk -LO https://github.com/IBM/cloud-pak/raw/master/repo/case/ibm-cp-automation/${CASE_MANAGER_VERSION}/ibm-cp-automation-${CASE_MANAGER_VERSION}.tgz
  mkdir -p ./ibm-cp-automation-${CASE_MANAGER_VERSION}
  tar xf ./ibm-cp-automation-${CASE_MANAGER_VERSION}.tgz -C ibm-cp-automation-${CASE_MANAGER_VERSION}
  cd ./ibm-cp-automation-${CASE_MANAGER_VERSION}/ibm-cp-automation/inventory/cp4aOperatorSdk/files/deploy/crs
  tar xf ./cert-k8s-*.tar
  cd ./cert-kubernetes/scripts/
  ls -al
  pwd
  cd ${CASE_MGR_HOME_FULL_PATH}

else
  echo "ERROR: folder ${CASE_MGR_HOME_FULL_PATH} doesn't exist !"
  exit
fi


