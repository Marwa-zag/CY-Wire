# CY-Wire
 Projet CY-Wire 2024-205
 Emma Danan
 Amine Taki
 Marwa Zagliz

 # Instructions avant la compilation
- Si vous utilisez les systèmes Ubuntu ou bien Debian, veuillez mettre à jour la liste des paquets disponibles à partir des dépôts logiciels configurés sur votre système :


                            `sudo apt-get update`

- Pour mettre en oeuvre CY-Wire,  vous aurez besoin de quelques outils dans votre terminal :

                               `sudo apt-get install gnuplot`(Gnuplot est utilisé pour générer des graphiques à partir des données)
                               `sudo apt-get install build-essential` (Pour compiler le programme en C, vous aurez besoin d'un compilateur C)
                               `sudo apt-get install make` ( utiliser l'utilitaire Make)


# Instructions pour l'éxécution

Commencez par insérer votre fichier à trier (data.csv) dans le dossier "data" prévu pour cela.

- Après avoir récupéré le dossier, donné lui les droits d'éxécution :

                                `chmod +x c-wire.sh`

 - Afin d'afficher la fonction d'aide, il suffit d'éxecuter dans le terminal (avant vérifier si le fichier `aide.txt` se situe dans le dossier Projet-CY-Wire) :
                                 `./c-wire.sh -h`


## Différents types de stations :

                                - hvb : Stations HV-B
                                - hva : Stations HV-A
                                - lv  : Postes LV

  ## Différents types de consommateurs :
  
                                - comp  : Entreprises
                                - indiv : Particuliers
                                - all   : Tous les consommateurs (uniquement pour 'lv')

   

   

  

