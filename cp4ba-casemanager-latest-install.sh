#!/bin/bash

CASE_MGR_HOME_FULL_PATH=$1

if [ "${CASE_MGR_HOME_FULL_PATH}" == "" ]; then
  echo "ERROR: env var CASE_MGR_HOME_FULL_PATH not set !"
  exit
fi

if [ -d "${CASE_MGR_HOME_FULL_PATH}" ]; then
  LATEST_CASE_VER=$(curl -sk https://raw.githubusercontent.com/IBM/cloud-pak/master/repo/case/ibm-cp-automation/index.yaml | grep latestVersion | sed 's/latestVersion: //g')
  LATEST_PAK_VER=$(curl -sk https://raw.githubusercontent.com/IBM/cloud-pak/master/repo/case/ibm-cp-automation/index.yaml | grep latestAppVersion | sed 's/latestAppVersion: //g')

  echo "Installing case version[${LATEST_CASE_VER}] pak version [${LATEST_PAK_VER}] into foder ${CASE_MGR_HOME_FULL_PATH}"
  mkdir -p ${CASE_MGR_HOME_FULL_PATH}
  cd ${CASE_MGR_HOME_FULL_PATH}
  curl -sk -LO https://github.com/IBM/cloud-pak/raw/master/repo/case/ibm-cp-automation/${LATEST_CASE_VER}/ibm-cp-automation-${LATEST_CASE_VER}.tgz
  mkdir -p ./ibm-cp-automation-${LATEST_CASE_VER}
  tar xf ./ibm-cp-automation-${LATEST_CASE_VER}.tgz -C ibm-cp-automation-${LATEST_CASE_VER}
  cd ./ibm-cp-automation-${LATEST_CASE_VER}/ibm-cp-automation/inventory/cp4aOperatorSdk/files/deploy/crs
  tar xf ./cert-k8s-*.tar
  cd ./cert-kubernetes/scripts/
  ls -al
  pwd
  cd ${CASE_MGR_HOME_FULL_PATH}

else
  echo "ERROR: folder ${CASE_MGR_HOME_FULL_PATH} doesn't exist !"
  exit
fi


