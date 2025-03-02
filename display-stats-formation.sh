#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

DEBUG=${DEBUG:=0}
[[ ${DEBUG} -eq 1 ]] && set -o xtrace
export DEBUG

code=${1:-9993}
input=reponses-etablissements.csv

fields_list=(
  "'Établissement'"
  "'Filière de formation'"
  "'cod_aff_form'"
  "'Sélectivité'"
  "'Capacité de l’établissement par formation'"
  "'Effectif total des candidats en phase principale'"
  "'Effectif des candidats néo bacheliers généraux en phase principale'"
  "'Effectif total des candidats classés par l’établissement en phase principale'"
  "'Effectif des candidats néo bacheliers généraux classés par l’établissement'"
  "'Effectif total des candidats ayant reçu une proposition d’admission de la part de l’établissement'"
  "'Effectif des admis néo bacheliers généraux'"
  "'% d’admis néo bacheliers sans mention au bac'"
  "'% d’admis néo bacheliers avec mention Assez Bien au bac'"
  "'% d’admis néo bacheliers avec mention Bien au bac'"
  "'% d’admis néo bacheliers avec mention Très Bien au bac'"
  "'Effectif des admis néo bacheliers généraux ayant eu une mention au bac'"
  "'Dont effectif des admis issus de la même académie'"
  "'Effectif des candidats en terminale générale ayant reçu une proposition d’admission de la part de l’établissement'"
  "'Taux d’accès'"
  "'Part des terminales générales qui étaient en position de recevoir une proposition en phase principale'"
  "'Lien de la formation sur la plateforme Parcoursup'"
)

fields=$(IFS=, ; echo "${fields_list[*]}")
color="--no-color"
color="--key-color white-bold"
#cmd="mlr --ifs ';' --icsv --ojson cut -o -f ${fields} ${input} | jq '.[] | select(.cod_aff_form == ${code})'"
cmd="mlr ${color} --ifs ';' --icsv --oxtab filter '\${cod_aff_form} == \"${code}\"' then cut -o -f ${fields} ${input}"

eval $(echo ${cmd})
