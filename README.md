# Parcoursup Stats exporter

La carte des formations sur Parcoursup est bien, mais dès qu'on veut avoir une vue d'ensemble rapide de toutes les formations pour un type d'étude donné (par ex. un BUT Informatique) ou si on veut rapidement visualiser et comparer des stats (comme nb de places, pourcentage d'admissions en fonction de son niveau, etc), ça devient limité, à moins d'ouvrir plusieurs onglets et de s'y perdre.
Il existe l'outil [SupTracker](https://beta.suptracker.org/) qui est plutôt pas mal, mais au moment où je l'ai utilisé, les données étaient celles de l'année précédente. Dommage qu'il ne soit pas mis plus en avant...

Heureusement, toutes les données des formations sur Parcoursup sont en accès libre sur Data.gouv !
Sur Data.gouv, on a accès à un autre outil intéressant : [l'Explorateur des données](https://explore.data.gouv.fr/fr/datasets/5f90f5c978b32276bad5f959/?Session__exact=2025#/resources/19e77c6b-9e90-4673-aaed-276b77ac9c69). C'est comme un spreadsheet, on peut filtrer sur toutes les colonnes. Il y a la liste de toutes les formations mais il manque les stats.

Encore heureusement, on peut les télécharger toutes les données des 14 000 formations avec les stats. Ce qui va nous permettre de filtrer sur les formations qui nous intéressent, puis les charger dans un spreadsheet. Ainsi, la comparaison des établissements de formation est beaucoup plus facile.
On pourra aussi visualiser rapidement les stats d'une formation spécifique sans avoir beoin d'ouvir la page web parcoursup de celle-ci.

Pour faire ceci, j'utilise l'outil [`miller`](https://github.com/johnkerl/miller). Ca fait quelques temps que je l'ai dans ma besace sans avoir eu un cas d'usage pour l'utiliser, là c'est l'occasion ! Il permet de manipuler aisément des fichier CSV, de faire des requêtes dedans comme on porrait le faire avec `jq` ou `yq` par exemple.

## Récupération des données

Tout se trouve ici [**Parcoursup 2024 - vœux de poursuite d'études et de réorientation dans l'enseignement supérieur et réponses des établissements**](https://data.enseignementsup-recherche.gouv.fr/explore/dataset/fr-esr-parcoursup/information/) dans l'ongler "Export".

On peut les télécharger sous différents formats, c'est le `csv` qui m'intéresse :

```
❯ curl -o reponses-etablissements.csv "https://data.enseignementsup-recherche.gouv.fr/api/explore/v2.1/catalog/datasets/fr-esr-parcoursup/exports/csv?lang=fr&timezone=Europe%2FBerlin&use_labels=true&delimiter=%3B"
```

Ce ne sera pas utile ici, mais si vous préférez utiliser `jq` pour parser du json :
```
❯ curl -o reponses-etablissements.json "https://data.enseignementsup-recherche.gouv.fr/api/explore/v2.1/catalog/datasets/fr-esr-parcoursup/exports/json?lang=fr&timezone=Europe%2FBerlin"
```

## Extraire les données d'une seule formation

Par exemple, pour extraire les formations sur les BUT Informatique dans le fichier `reponses-etablissements_BUT-Informatique.csv` :

```
❯ ./extract-filiere-formation.sh "BUT - Informatique"
❯ wc -l reponses-etablissements_BUT-Informatique.csv
51 reponses-etablissements_BUT-Informatique.csv
```

Le script prend en entrée le fichier `reponses-etablissements.csv` téléchargé précédemment.

On peut ouvrir ce fichier dans son éditeur de spreadsheet préféré.

## Afficher les stats d'une formation

Par exemple, pour affichier les stats qui nous intéressent pour une formation données, ici le BUT Informatique de Vélizy (code `9993`)

```
❯ ./display-stats-formation.sh 9993
Établissement                                                                                                     I.U.T de Velizy
Filière de formation                                                                                              BUT - Informatique
cod_aff_form                                                                                                      9993
Sélectivité                                                                                                       formation sélective
Capacité de l’établissement par formation                                                                         76
Effectif total des candidats en phase principale                                                                  2773
Effectif des candidats néo bacheliers généraux en phase principale                                                1426
Effectif total des candidats classés par l’établissement en phase principale                                      1152
Effectif des candidats néo bacheliers généraux classés par l’établissement                                        718
Effectif total des candidats ayant reçu une proposition d’admission de la part de l’établissement                 610
Effectif des admis néo bacheliers généraux                                                                        33
% d’admis néo bacheliers sans mention au bac                                                                      18.0
% d’admis néo bacheliers avec mention Assez Bien au bac                                                           49.0
% d’admis néo bacheliers avec mention Bien au bac                                                                 25.0
% d’admis néo bacheliers avec mention Très Bien au bac                                                            7.0
Effectif des admis néo bacheliers généraux ayant eu une mention au bac                                            30
Dont effectif des admis issus de la même académie                                                                 54
Effectif des candidats en terminale générale ayant reçu une proposition d’admission de la part de l’établissement 347.0
Taux d’accès                                                                                                      28.0
Part des terminales générales qui étaient en position de recevoir une proposition en phase principale             65.0
Lien de la formation sur la plateforme Parcoursup                                                                 https://dossier.parcoursup.fr/Candidats/public/fiches/afficherFicheFormation?g_ta_cod=9993
```

Les intitulés sont ceux du csv `reponses-etablissements.csv`. Si vous voulez d'autres stats que celles affichées, ill suffit d'ajouter l'intitulé dans le tableau `fields_list` du script.
