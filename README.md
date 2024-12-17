# CY-Wire
 Projet CY-Wire 2024-205
 Emma Danan
 Amine Taki
 Marwa Zagliz
 Préing2 MEF1

 # Instructions avant la compilation
- Si vous utilisez les systèmes Ubuntu ou bien Debian, veuillez mettre à jour la liste des paquets disponibles à partir des dépôts logiciels configurés sur votre système :


                            `sudo apt-get update`

- Pour mettre en oeuvre CY-Wire,  vous aurez besoin de quelques outils dans votre terminal :

                               `sudo apt-get install gnuplot`(Gnuplot est utilisé pour générer des graphiques à partir des données)
                               `sudo apt-get install build-essential` (Pour compiler le programme en C, vous aurez besoin d'un compilateur C)
                               `sudo apt-get install make` ( utiliser l'utilitaire Make)


# Instructions pour l'éxécution

Créer un dossier "data". Insérer votre fichier à trier (data.csv) dans le dossier "data" prévu pour cela.

- Après avoir récupéré le dossier, donné lui les droits d'éxécution :

                                `chmod +x c-wire.sh`

- Avant d'éxecuter le programme C, veuillez donner les droits d'éxécution au dossier "progC" :
                                 `chmod +x progC`

Ensuite veuillez accéder au dossier progC : 
                           `cd progC`
Ensuite veuillez supprimer les fichiers compilés pour repartir sur une base propre et enfin à compiler le projet en suivant les règles du Makefile. Apeès avoir fait cela veuillez quitter le dossier progC et revenir dans le dossier d'origine Projet-CY-Wire :
                            `make clean`
                            `make`
                            ` cd -`

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


## Exemples d'exécutions appelées :

- Afficher le résultat demandé pour la station HVB avec son type de consommateur :
         
                           ./c-wire.sh data/c-wire_v25.dat hvb comp

- Afficher le résultat demandé pour la station HVA avec son type de consommateur et l'ID de la centrale souhaitée :

                             ./c-wire.sh data/c-wire_v25.dat hva comp 4

  ## Aperçu d'une éxécution en cours...

  <img width="658" alt="Capture d’écran 2024-12-15 à 21 10 56" src="https://github.com/user-attachments/assets/877c30c4-2260-4f36-90d4-984358581a76" />

  
  ## Aperçu de la fonction d'affichage

  <img width="1157" alt="Capture d’écran 2024-12-15 à 21 12 59" src="https://github.com/user-attachments/assets/2821cf3e-56d2-4508-a97c-b52033278bdb" />

  ## Sources :
  
  - Vidéos youtube.
  - Site internet concernant la partie shell et C.
  - TD et CM pour les différentes fonctions des traitements tels que les AVL, les différentes rotations, Shell...
  




  

  

   

  

