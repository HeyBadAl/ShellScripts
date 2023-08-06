#!/bin/bash 

# Move to parent folder 
SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE unitl the file is no longer a symblink 
while [ -h "${SOURCE}" ]; do 
  readonly BIN_DIR="$(cd -P "$(dirname "${SOURCE}")" && pwd)"
  SOURCE="$(readlink "${SOURCE}")"
  # if $SOURCE was a relative symblink, we need to resolve to the path where the symblink file was located 
  [[ ${SOURCE} != /* ]] && SOURCE="${BIN_DIR}/${SOURCE}"
done 

readonly DIR="$(cd -P "$(dirname "${SOURCE}")" && pwd)"
# Move to this directory's parent 
cd "${DIR}/.."

if ! RES=$(kubectl deprecations --input-file Pod/simple.yml 2>&1)
then 
  echo '`kubectl deprecations` did not run ok. You may need to install the krew 'deprecations' pacakge. See https://krew.sigs.k8s.io/'
  echo 'OUTPUT:'
  echo "${RES}"
  exit 1 
fi 

if [[ $# -eq 0 ]]
then  
  while IFS=read -r line 
  do 
    echo "======================================================================="
    echo "Looking at k8s version: ${line}"
    echo "======================================================================="
    for f in $(find . -type -f -name "*.yml")
    do 
      echo -n "${f}"
      if RES=$(kubectl deprecations --error-on-deleted --error-on-deprecated --k8s-version="$line" --input-file "${f}" 2>&1)
      then 
        echo '....OK'
      else
        echo "======================================================================="
        echo "Problem with file: ${f} on k8s version ${line}"
        echo "======================================================================="
        echo "Output was: ${RES}"
        echo "======================================================================="
        echo 
        echo "Checking files.... "
      fi 
    done 
  done < .supported-k8s-versions 
else 
  find . -type -f -name "*.yml" -exec echo {} \; -exec kubectl deprecations --error-on-deleted --error-on-deprecated --k8s-version="$v$1" --input-file {} \;





























