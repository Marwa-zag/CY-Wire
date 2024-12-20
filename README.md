# CY-Wire
 Projet CY-Wire 2024-2025
 Emma Danan
 Amine Taki
 Marwa Zagliz
 Préing2 MEF1

 # Structure du dossier Projet-CY-Wire

<img width="841" alt="Capture d’écran 2024-12-18 à 10 50 28" src="https://github.com/user-attachments/assets/fe646777-a5c4-4646-8e49-75e3383539dc" />

 

 # Instructions avant la compilation
- Si vous utilisez les systèmes Ubuntu ou bien WSL/Ubuntu, veuillez mettre à jour la liste des paquets disponibles à partir des dépôts logiciels configurés sur votre système :


                            `sudo apt-get update`

- Pour mettre en oeuvre CY-Wire,  vous aurez besoin de quelques outils dans votre terminal :

                               `sudo apt-get install gnuplot`(Gnuplot est utilisé pour générer des graphiques à partir des données)
                               `sudo apt-get install build-essential` (Pour compiler le programme en C, vous aurez besoin d'un compilateur C)
                               `sudo apt-get install make` (utiliser l'utilitaire Make)
                               `sudo apt-get install gcc`   (utiliser l'utilitaire gcc)
  

# Instructions pour l'éxécution

Après avoir téléchargé le dossier `Projet-CY-Wire`, veuillez y accéder : 

                                  ` cd Projet-CY-Wire`

Insérer votre fichier à trier (c-wire_v25.dat) dans le dossier "data" prévu pour cela.

- Après avoir récupéré le dossier, attribuez les droits d'éxécution au fichier `c-wire.sh` :

                                `chmod +x c-wire.sh`

- Avant d'éxecuter le programme C, attribuez les droits d'éxécution au dossier "progC" :
  
                                 `chmod +x progC`

                - Ensuite, accédez au dossier progC :
                                                       `cd progC`
  
                - Supprimez les fichiers compilés pour repartir sur une base propre :
                                                       `make clean`
  
                -  Puis compilez le projet en respectant les règles définies dans le Makefile :
                                                       `make`
  
                - Enfin, quittez le dossier progC et revenez dans le dossier d'origine Projet-CY-Wire :
                                                       ` cd -`


 - Afin d'afficher la fonction d'aide, il suffit d'éxecuter dans le terminal (avant vérifier si le fichier `aide.txt` se situe dans le dossier Projet-CY-Wire) :
                                 `./c-wire.sh -h`

- Afficher le résultat demandé pour la station HVA avec son type de consommateur :
         
                           ./c-wire.sh data/c-wire_v25.dat hva comp



## Différents types de stations :

                                - hvb : Stations HV-B
                                - hva : Stations HV-A
                                - lv  : Postes LV

  ## Différents types de consommateurs :
  
                                - comp  : Entreprises
                                - indiv : Particuliers
                                - all   : Tous les consommateurs (uniquement pour 'lv')


## Exemples d'exécutions appelées :

- Afficher la somme des consommations et des capacités pour la station HVB avec son type de consommateur :
         
                           ./c-wire.sh data/c-wire_v25.dat hvb comp
  

- Afficher le résultat demandé pour la station HVA avec son type de consommateur et l'ID de la centrale souhaitée :

                             ./c-wire.sh data/c-wire_v25.dat hva comp 4

  ## Fichiers de sortie après l'exécution du programme:

  #### Pour la station HVB :
    * `converted_data.csv` : convertit les sépareteurs du fichier ';' en ':'
    * `hvb_comp.csv` ; récupére l'ID de la station, sa capacité et sa consommation  des entreprises.
    * `hvb_comp_somme.csv` : récupére l'ID de la station, la somme de la capacité et la consommation des entreprises.

  ####  Pour la station HVA :
    * `converted_data.csv` : convertit les sépareteurs du fichier ';' en ':'
    * `hva_comp.cs`v ; récupére l'ID de la station, sa capacité et sa consommation des entreprises.
    * `hva_comp_somme.csv` : récupére l'ID de la station, la somme de la capacité et la consommation des entreprises.
   

  #### Pour la station LV, son type de consommateur comp :
    * `converted_data.csv` : convertit les sépareteurs du fichier ';' en ':'
    * `lv_comp.csv` ; récupére l'ID de la station, sa capacité et la consommation des entreprises.
    * `lv_comp_somme.csv` : récupére l'ID de la station, la somme de la capacité et la consommation des entreprises.

  #### Pour la station LV, son type de consommateur indiv :
    * `converted_data.csv` : convertit les sépareteurs du fichier ';' en ':'
    * `lv_indiv.csv` ; récupére l'ID de la station, sa capacité et la consommation des particuliers.
    * `lv_indiv_somme.csv` : récupére l'ID de la station, la somme de la capacité et la consommation des particuliers.


 #### Pour la station LV, son type de consommateur all :
   * `converted_data.csv` : convertit les sépareteurs du fichier ';' en ':'
   * `lv_all.csv` ; récupére l'ID de la station, sa capacité et sa consommation.
   * `lv_all_somme.csv` : récupére l'ID de la station, la somme de la capacité et la consommation.
   * `lv_max_10.csv` : Trie les données par consommation, les 10 plus grandes consommations.
   * `lv_min_10.csv` : Trie les données par consommation, les 10 plus faibles consommations.
   * `lv_all_minmax.csv` : Trie les données en fonction de la valeur croissante de la différence entre la capacité totale et la consommation totale, fusionne les fichiers max et min.
   * `diff_sorted.csv` :  la différence entre la capacité totale et la consommation totale, et trie les données en fonction de la valeur croissante de la différence entre la capacité totale 

  ## Aperçu d'une éxécution en cours...

  <img width="658" alt="Capture d’écran 2024-12-15 à 21 10 56" src="https://github.com/user-attachments/assets/877c30c4-2260-4f36-90d4-984358581a76" />

  
  ## Aperçu de la fonction d'affichage

  <img width="1157" alt="Capture d’écran 2024-12-15 à 21 12 59" src="https://github.com/user-attachments/assets/2821cf3e-56d2-4508-a97c-b52033278bdb" />

  ## Graphique généré pour la station LV, son type de consommateur all

  Par exemple  : `./c-wire.sh data/c-wire_v25.dat lv all`

![graphique_lvminmax](https://github.com/user-attachments/assets/19f482a1-bfc4-46eb-ae3a-166b6551f2f0)

Par exemple  : `./c-wire.sh data/c-wire_v25.dat lv all 2`. Le 2 représente l'ID unique de la centrale n°2.


![graphique_lvminmax_2](https://github.com/user-attachments/assets/23a46fba-ce57-4b6c-a0a5-62a24ca1ea54)


  

  ## Sources :
  
  - Vidéos youtube.
  - Site internet concernant la partie shell et C.
  - TD et CM pour les différentes fonctions des traitements tels que les AVL, les différentes rotations, Shell...
  




  

  

   

  

