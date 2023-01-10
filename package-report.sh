#!/bin/bash

# INSTALLED_PACKAGES=()

# while read -r package
# do
#   INSTALLED_PACKAGES+=("$package")
# done < <(kubectl get packageinstall -A -o json | jq -c '.items[] | [.metadata.namespace, .metadata.name, .status.version]')

function check_ver {
  namespace=$1
  packageinstall=$2
  packageref=$3
  packageversion=$4

  upgradeversions=""
  for version in $(kubectl get package -n $namespace --field-selector "spec.refName=$packageref" -o jsonpath='{.items[*].spec.version}'); do
    if [ "$(lib/semver2/semver2.sh $packageversion $version)" == "-1" ]; then
      if [ -z "$upgradeversions"]; then 
        upgradeversions=$version
      else 
        upgradeversions+=" $version"
      fi
    fi 
  done

  if [ ! -z "$upgradeversions" ]; then
    echo "Namespace: $namespace"
    echo "Package Install: $packageinstall"
    echo "Installed Version: $packageversion"
    printf "Available Upgrades: %s\n\n" "$upgradeversions"
  fi
}
export -f check_ver

kubectl get packageinstall -A -o json | jq -c '.items[] | [.metadata.namespace, .metadata.name, .spec.packageRef.refName, .status.version] | @sh' | xargs -n 1 | xargs -n 4 bash -c 'check_ver "$@"' _
