# Install CP4BA Case Manager package

Utilities for IBM Cloud Pak® for Business Automation

<i>Last update: 2024-08-05</i> use '<b>main</b>' for latest updates (see changelog.md for details)

Usage

```
./cp4ba-casemgr-install.sh
  -d target-directory [must exists]
  -v(optional) package-version [if not set will install latest version]
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
_CMGR_FOLDER="/tmp/cmgr-$USER"
_CMGR_VER="5.1"
mkdir -p ${_CMGR_FOLDER}
./cp4ba-casemgr-install.sh -d ${_CMGR_FOLDER} -v ${_CMGR_VER}
```

