# Install CP4BA Case Manager package

Utilities for IBM Cloud Pak® for Business Automation

<i>Last update: 2026-04-04</i> use '<b>main</b>' for latest updates (see changelog.md for details)

Usage

```
./cp4ba-casemgr-install.sh
  -d target-directory [must exists]
  -v(optional) package-version [if not set will install latest version]
  -k(optional) cert-kubernetes specific version [if not set will install latest version]
  -n(optional) move-to-scripts-folder [if set move the shell to folder scripts]
  -r(optional) remove-tar-file [if set deletes the tarball]
  -s(optional) show-available-versions [if set display all the avilable versions and exits]
```

## Show only available versions
```
./cp4ba-casemgr-install.sh -s
```

## Latest version
```
_CMGR_FOLDER="/tmp/cmgr-$USER"
mkdir -p ${_CMGR_FOLDER}
./cp4ba-casemgr-install.sh -d ${_CMGR_FOLDER}
```

## Specific version
```

### example: version 23.0.2-IF006 old mapping value is 5.1.6, 
_CMGR_FOLDER="/tmp/cmgr-$USER"
_CMGR_VER="5.1.6"
./cp4ba-casemgr-install.sh -d ${_CMGR_FOLDER} -v ${_CMGR_VER}


### example: version 24.1.7 and fix 24.0.1-IF007
_CMGR_FOLDER="/tmp/cmgr-$USER"
_CMGR_VER="24.1.7"
_K_VER="24.0.1-IF007"
./cp4ba-casemgr-install.sh -d ${_CMGR_FOLDER} -v ${_CMGR_VER} -k ${_K_VER}

### example: version 25.0.4 and fix package automatically discovered [PREFERRED]
_CMGR_FOLDER="/tmp/cmgr-$USER"
_CMGR_VER="25.0.4"
./cp4ba-casemgr-install.sh -d ${_CMGR_FOLDER} -v ${_CMGR_VER}

### example: version 25.1.1 and fix package, move shell to scripts folder, remove .tar file
_CMGR_FOLDER="/tmp/cmgr-$USER"
_CMGR_VER="25.1.1"
_K_VER="25.0.1-IF001"
./cp4ba-casemgr-install.sh -d ${_CMGR_FOLDER} -v ${_CMGR_VER} -n -r

```
### WARNING for version 25.1.0

Bug in https://github.com/IBM/cloud-pak/blob/master/repo/case/ibm-cp-automation/index.yaml

incorrect mapping for tag '25.1.0' mapping a 'appVersion: 25.1.0' unexistent 25.1.0.zip file.

See https://github.com/icp4a/cert-kubernetes/archive/refs/heads/25.0.1.zip

For v 25.1.0 use 'specific method'

```
_CMGR_FOLDER="/tmp/cmgr-$USER"
_CMGR_VER="25.1.0"
_K_VER="25.0.1"
./cp4ba-casemgr-install.sh -d ${_CMGR_FOLDER} -v ${_CMGR_VER} -k ${_K_VER}
```
