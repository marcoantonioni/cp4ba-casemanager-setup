#!/bin/bash

_me=$(basename "$0")

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

_DIR=""
_VER=""
_STAY=true
_REMOVE_TGZ=false
_SHOW_VERSIONS=false

#--------------------------------------------------------
_CLR_RED="\033[0;31m"   #'0;31' is Red's ANSI color code
_CLR_GREEN="\033[0;32m"   #'0;32' is Green's ANSI color code
_CLR_YELLOW="\033[1;32m"   #'1;32' is Yellow's ANSI color code
_CLR_BLUE="\033[0;34m"   #'0;34' is Blue's ANSI color code
_CLR_NC="\033[0m"

# "\33[32m[✔] ${1}\33[0m"
# "\33[33m[✗] ${1}\33[0m"
# bold: echo -e "\x1B[1m${1}\x1B[0m\n"

#--------------------------------------------------------
# read command line params
while getopts d:v:nrs flag
do
    case "${flag}" in
        d) _DIR=${OPTARG};;
        v) _VER=${OPTARG};;
        n) _STAY=false;;
        r) _REMOVE_TGZ=true;;
        s) _SHOW_VERSIONS=true;;
    esac
done

_CASE_VER=""
_CP4BA_VER=""
_CP4AUTO_INDEX_FILE="https://raw.githubusercontent.com/IBM/cloud-pak/master/repo/case/ibm-cp-automation/index.yaml"

#---------------------------
getLatestVersion () {
  _CASE_VER=$(curl -sk ${_CP4AUTO_INDEX_FILE} | grep latestVersion | sed 's/latestVersion: //g')
  _CP4BA_VER=$(curl -sk ${_CP4AUTO_INDEX_FILE} | grep latestAppVersion | sed 's/latestAppVersion: //g')
  _VER="${_CASE_VER}"
}

#---------------------------
getSpecificVersion () {
  _CASE_VER="${_VER}"
  _CP4BA_VER=$(curl -sk ${_CP4AUTO_INDEX_FILE} | grep "${_VER}:" -A1 | grep appVersion | sed 's/appVersion: //g' | sed 's/^ *//g')
  if [[ -z "${_CP4BA_VER}" ]]; then
    _CASE_VER=""
  fi
}

#---------------------------
installCasePackMgr () {
  echo -e "${_CLR_YELLOW}=============================================================="
  echo -e "${_CLR_YELLOW}Installing case manager version '${_CLR_GREEN}${_CASE_VER}${_CLR_YELLOW}' for CP4BA version '${_CLR_GREEN}${_CP4BA_VER}${_CLR_YELLOW}' into foder '${_CLR_GREEN}${_DIR}${_CLR_YELLOW}'${_CLR_NC}"
  echo -e "==============================================================${_CLR_NC}"

  # echo ""
  if [[ -z "${_CASE_VER}" ]]; then
    echo -e "${_CLR_RED}[✗] \x1b[5mERROR\x1b[25m: CP4BA Case Manager version '${_CLR_GREEN}${_VER}${_CLR_RED}' doesn't exist !${_CLR_NC}"
    exit 1
  fi
  mkdir -p ${_DIR}
  cd ${_DIR}
  curl -sk -LO https://github.com/IBM/cloud-pak/raw/master/repo/case/ibm-cp-automation/${_CASE_VER}/ibm-cp-automation-${_CASE_VER}.tgz
  mkdir -p ./ibm-cp-automation-${_CASE_VER}
  tar xf ./ibm-cp-automation-${_CASE_VER}.tgz -C ibm-cp-automation-${_CASE_VER} 1>/dev/null

  if [[ "${_REMOVE_TGZ}" = "true" ]]; then
    rm ${_DIR}/ibm-cp-automation-${_CASE_VER}.tgz
  fi

  # if < 24
  if [[ ${_CASE_VER} = 5.* ]]; then
    cd ./ibm-cp-automation-${_CASE_VER}/ibm-cp-automation/inventory/cp4aOperatorSdk/files/deploy/crs
    tar xf ./cert-k8s-*.tar 1>/dev/null
    if [[ "${_REMOVE_TGZ}" = "true" ]]; then
      rm ${_DIR}/ibm-cp-automation-${_CASE_VER}.tgz
    fi
  else
    if [[ ${_CASE_VER} = 2*.* ]]; then
      _OLOC=$(pwd)
      mkdir -p ./ibm-cp-automation-${_CASE_VER}/ibm-cp-automation/inventory/cp4aOperatorSdk/files/deploy/crs
      cd ./ibm-cp-automation-${_CASE_VER}/ibm-cp-automation/inventory/cp4aOperatorSdk/files/deploy/crs
      wget https://github.com/icp4a/cert-kubernetes/archive/refs/heads/${_CP4BA_VER}.zip
      unzip -o ${_CP4BA_VER}.zip 1>/dev/null
      mv ./cert-kubernetes-${_CP4BA_VER} ./cert-kubernetes
      if [[ "${_REMOVE_TGZ}" = "true" ]]; then
        rm ./${_CP4BA_VER}.zip
      fi
      cd ${_OLOC}
    else
      echo -e "${_CLR_RED}[✗] \x1b[5mERROR\x1b[25m: CP4BA Case Manager version '${_CLR_GREEN}${_VER}${_CLR_RED}'  not supported !${_CLR_NC}"
      exit 1
      
    fi
  fi

  _SCRIPTS_FOLDER=${_DIR}"/ibm-cp-automation-${_CASE_VER}/ibm-cp-automation/inventory/cp4aOperatorSdk/files/deploy/crs/cert-kubernetes/scripts/"
  # echo "Scripts folder: ${_SCRIPTS_FOLDER}"
  if [[ "${_STAY}" = "false" ]]; then
    cd ${_SCRIPTS_FOLDER}
    echo "New bash shell is now in '${_SCRIPTS_FOLDER}' folder, type exit to return to prev. shell"
    exec bash
  fi

}

#===================================

if [[ "${_SHOW_VERSIONS}" = "true" ]]; then
  echo "--------------------------------------------------"
  echo -e "${_CLR_GREEN}"
  curl -sk ${_CP4AUTO_INDEX_FILE}
  echo -e "${_CLR_NC}"
  echo "--------------------------------------------------"
  exit 1
fi

if [[ -z "${_DIR}" ]] ; then
  echo -e "usage: $_me\n  -d target-directory\n -v(optional) package-version\n  -n(optional) move-to-scripts-folder\n  -r(optional) remove-tar-file\n  -s(optional) show-available-versions"
  exit 1
fi

if [[ -z "${_VER}" ]]; then
  getLatestVersion
else
  getSpecificVersion
fi
installCasePackMgr
exit 0
