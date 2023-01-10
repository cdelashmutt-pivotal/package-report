# A script for viewing upgradable kapp-controller PackageInstalls

This script looks up all the kapp-controller PackageInstall objects in whatever cluster your kubeconfig is currently pointing at, and checks to see if any installed packages have upgrade versions available.  The script only produces output if it finds a PackageInstall that is using a version of a package that has a later version of that package available (using semver rules).

This script requires bash, kubectl, and jq to function.

## Usage
```
$ ./package-report.sh

Namespace: default
Package Install: cert-manager
Installed Version: 1.5.3+vmware.4-tkg.1
Available Upgrades: 1.7.2+vmware.1-tkg.1
...
```
