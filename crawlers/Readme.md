# Intégration des monnaies
Ce répertoire contient les scripts d'intégration des tokens et monnaies dans le fichier crypto.json.

## Intégration des nouvelles monnaies
 - Récupération de la liste sur coinmarketcap dans le fichier toto.json
> 1 ./lanceDownload.sh -> La sortie indique comment faire l'injection dans le fichier cryptos.json

*Le script addNewCryptosFromFreshData s'arrête si une monnaie est renommée. Il faut corriger le fichier avant*
Si tout est ok, déplacer le fichier à la place du fichier de crypto.json et commiter le. Les nouvelles monnaies sont taguées 'New'
> 3 mv toto.json ../cryptos.json
> 4 git commit -am'Ajout crypot' && git push

## Crawl des nouvelles monnaies
Lancer le script de récupération des données des monnaie.
Le script intègre, les numéros de token, les tags, et les références github.

> 5 ./lanceUpdateFresh.sh

Un fichier de statistiques est créé à la fin du script

## Crawl de github pour récupérer les licences
> 6 ./lanceGitHub.sh
