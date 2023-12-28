# Install CP4BA Case Manager package

Usage

```
./cp4ba-casemgr-install.sh
  -d target-directory [must exists]
  -v(optional) package-version [if not set will install latest version]
  -n(optional) move-to-scripts-folder [if set move the shell to folder scripts]
  -r(optional) remove-tar-file [if ser deletes the tarball]
  -s(optional) show-available-versions [if set display all the avilable versions and exits]
```

## Show only available versions
```
./cp4ba-casemgr-install.sh -s
```

## Latest version
```
mkdir -p /tmp/test
./cp4ba-casemgr-install.sh -d /tmp/test
```

## Specific version
```
mkdir -p /tmp/test
./cp4ba-casemgr-install.sh -d /tmp/test -v 5.2
```


