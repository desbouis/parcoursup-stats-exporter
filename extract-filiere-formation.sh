#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

DEBUG=${DEBUG:=0}
[[ ${DEBUG} -eq 1 ]] && set -o xtrace
export DEBUG

formation=${1:-"BUT - Informatique"}
input=reponses-etablissements.csv
output="reponses-etablissements_${formation// /}.csv"

cmd="mlr --ifs ';' --ofs ';' --icsv --ocsv filter '\${Filière de formation} == \"${formation}\"' ${input} > ${output}"

eval $(echo ${cmd})
ls -alh ${output}