# CY-Wire
 Projet CY-Wire 2024-2025
 * Emma Danan
 * Amine Taki
 * Marwa Zagliz

 Préing2 MEF1


 # Présentation du Projet CY-Wire

 Présentation du projet C-Wire

Le projet C-Wire a pour objectif de développer un programme informatique permettant d'analyser et de synthétiser des données issues d'un système de distribution d’électricité. Ces données, fournies sous la forme d’un fichier CSV volumineux, modélisent un réseau énergétique complexe allant des centrales électriques aux consommateurs finaux (entreprises et particuliers).

L’analyse porte sur différents niveaux du réseau : les centrales, les sous-stations haute tension (HV-B et HV-A) et les postes basse tension (LV). Chaque élément joue un rôle clé dans la transmission et la consommation d'énergie, et le projet vise à évaluer leur état de fonctionnement. Plus précisément, le programme doit identifier les situations de surproduction ou de sous-production d’énergie, ainsi que calculer la part d'énergie consommée par les différentes catégories d'utilisateurs.

## Objectifs principaux :

1. Filtrer les données pertinentes à partir du fichier CSV en fonction des paramètres définis par l'utilisateur.
2. Traiter ces données pour calculer les consommations totales par station, tout en utilisant des structures de données efficaces comme des arbres AVL.
3. Générer des résultats clairs et structurés (fichiers CSV), permettant une analyse approfondie du réseau.

En bonus, produire des graphiques synthétiques pour visualiser les consommations des postes LV les plus et les moins sollicités.

## Processus de téléchargement du projet 

1. Téléchargez le dossier du projet, qui sera fourni au format ZIP.  
2. Décompressez le fichier ZIP pour extraire son contenu.  
3. Récupérez le dossier **Projet-CY-Wire** et placez-le soit :  
   - Dans l'explorateur de fichiers, à l'emplacement de votre choix.  
   - Dans le dossier **home** si vous utilisez Ubuntu.  
4. Ouvrez un terminal et accédez au dossier **Projet-CY-Wire**.  

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

- Affiche la somme des consommations et des capacités pour la station HVB avec son type de consommateur :
         
                           ./c-wire.sh data/c-wire_v25.dat hvb comp

  Résultat après exécution :
  
<img width="659" alt="Capture d’écran 2024-12-22 à 16 56 37" src="https://github.com/user-attachments/assets/963a4d66-93d5-4e82-9b3b-1bb50549b481" />


- Affiche le résultat demandé pour la station HVA avec son type de consommateur et l'ID de la centrale souhaitée :

                             ./c-wire.sh data/c-wire_v25.dat hva comp 4
  
 Résultat après exécution :

<img width="659" alt="Capture d’écran 2024-12-22 à 16 57 26" src="https://github.com/user-attachments/assets/e3031135-ba41-46c3-8a16-9cb390bb16df" />


  ## Fichiers de sortie après l'exécution du programme:

  #### Pour la station HVB :
   * temp/`converted_data.csv` : convertit les sépareteurs du fichier ';' en ':'
   * temp/`hvb_comp.csv` ; récupére l'ID de la station, sa capacité et sa consommation  des entreprises.
   * tests/`hvb_comp_somme.csv` : récupére l'ID de la station, la somme de la capacité et la consommation des entreprises.

  ####  Pour la station HVA :
   * temp/`converted_data.csv` : convertit les sépareteurs du fichier ';' en ':'
   * temp/`hva_comp.cs`v ; récupére l'ID de la station, sa capacité et sa consommation des entreprises.
   * tests/`hva_comp_somme.csv` : récupére l'ID de la station, la somme de la capacité et la consommation des entreprises.
   

  #### Pour la station LV, son type de consommateur comp :
   * temp/`converted_data.csv` : convertit les sépareteurs du fichier ';' en ':'
   * temp/`lv_comp.csv` ; récupére l'ID de la station, sa capacité et la consommation des entreprises.
   * tests/`lv_comp_somme.csv` : récupére l'ID de la station, la somme de la capacité et la consommation des entreprises.

  #### Pour la station LV, son type de consommateur indiv :
   * temp/`converted_data.csv` : convertit les sépareteurs du fichier ';' en ':'
   * temp/`lv_indiv.csv` ; récupére l'ID de la station, sa capacité et la consommation des particuliers.
   * tests/`lv_indiv_somme.csv` : récupére l'ID de la station, la somme de la capacité et la consommation des particuliers.


 #### Pour la station LV, son type de consommateur all :
   * temp/`converted_data.csv` : convertit les sépareteurs du fichier ';' en ':'
   * temp/`lv_all.csv` ; récupére l'ID de la station, sa capacité et sa consommation.
   * tests/`lv_all_somme.csv` : récupére l'ID de la station, la somme de la capacité et la consommation.
   * temp/`diff_sorted.csv` :  la différence entre la capacité totale et la consommation totale, et trie les données en fonction de la valeur croissante de la différence entre la capacité totale
   * temp/`lv_max_10.csv` : Trie les données par consommation, les 10 plus grandes consommations.
   * temp/`lv_min_10.csv` : Trie les données par consommation, les 10 plus faibles consommations.
   * tests/`lv_all_minmax.csv` : Trie les données en fonction de la valeur croissante de la différence entre la capacité totale et la consommation totale, fusionne les fichiers max et min. 

  ## Divers appels d'exécution

  - Pour afficher la somme des consommations et des capacités pour la station LV avec son type de consommateur indiv :

<img width="659" alt="Capture d’écran 2024-12-22 à 16 59 29" src="https://github.com/user-attachments/assets/0fa892cd-14bb-4270-a2d5-1c46c3b065ae" />

  
  - Afin d'afficher la fonction d'aide, il suffit d'éxecuter dans le terminal (avant vérifier si le fichier `aide.txt` se situe dans le dossier Projet-CY-Wire) :
                                 `./c-wire.sh -h`

<img width="1161" alt="Capture d’écran 2024-12-22 à 18 38 24" src="https://github.com/user-attachments/assets/f75f5736-af09-4cc2-9394-dc9a6b023d89" />


  ## Combinaisons Interdites

**Stations HV-B :** Si vous choisissez "hvb all" ou "hvb indiv", un message d'erreur s’affichera, car seules les entreprises peuvent être analysées pour ce type de station.
 - Par exemple : `./c-wire.sh data/c-wire_v25.dat hvb all`

<img width="1161" alt="Capture d’écran 2024-12-22 à 19 37 37" src="https://github.com/user-attachments/assets/00fdfccf-e3ac-4ef0-a7fb-bfbd3f6b49be" />


**Stations HV-A :** Si vous choisissez "hva all" ou "hva indiv", un message d'erreur s’affichera, car seules les entreprises peuvent être analysées pour ce type de station.  

 - Par exemple : `./c-wire.sh data/c-wire_v25.dat hva indiv`

 <img width="1161" alt="Capture d’écran 2024-12-22 à 19 37 47" src="https://github.com/user-attachments/assets/a4f720a1-2654-48d3-bada-5b589312d8e1" />


**Postes LV :** Toutes les options sont autorisées (entreprises, particuliers, ou tous les consommateurs), aucun message d’erreur ne sera généré.


## Plus de détails

Pour plus de détails sur le projet, veuillez consulter le rapport qui contient une explication approfondie du Projet.
  

  ## Sources :
  
  - Vidéos youtube.
  - Site internet concernant la partie shell et C.
  - TD et CM pour les différentes fonctions des traitements tels que les AVL, les différentes rotations, Shell...
  




  

  

   

  

