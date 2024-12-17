# CY-Wire
 Projet CY-Wire 2024-205
 Emma Danan
 Amine Taki
 Marwa Zagliz
 Préing2 MEF1

 # Structure du projet

 Projet-CY-Wire/
│
├── data/              # Contient le fichier de données CSV (data.csv)
│   └── c-wire_v25.dat
│
├── progC/              # Contient le code source C et les fichiers associés
│   ├── main.c          # Programme principal en C
│   ├── avl.c           # Module pour gérer les AVL
│   ├── avl.h           # Header du module AVL        
│   ├── Makefile        # Règles pour compiler le projet
│   └── c-wire          # Exécutable généré après compilation
│
├── temp/              # Résultats d'exécution pour tests HVB
│   ├── converted_data.csv      # fichier qui convertit le séparateur ; en :
│   ├── hvb_comp.csv            # Résultats pour HVB avec tous les entreprises
│   └── hvb_somme_comp.csv      # Résultats pour HVB avec tous les entreprises, incluant la somme des capacités et des consommations
│
├── test/                # Fichiers créés pendant l'exécution (un exemple)
│   └── *               
│
├── graphs/             # Graphiques générés 
│   ├── lv_minmax.png   # Barres des 10 postes LV les plus et moins chargés
│   
│
├── c-wire.sh           # Script Shell pour automatiser les traitements
│
├── descriptif.pdf      # Rapport du projet
└── README.md           # Instructions pour compiler et exécuter le projet


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

  - Pour la station HVB/HVA, son type de consommateur comp et pour la station LV, son type de consommateur indiv et comp :
    * Par exemple pour la station HVB :
      * `converted_data.csv` : convertit les sépareteurs du fichier ';' en ':'
        * `hvb_comp.cs`v ; récupére l'ID de la station, sa capacité et sa consommation.
          * `hv_comp_somme.csv` : récupére l'ID de la station, la somme de la capacité et la consommation.

-  Pour la station LV, son type de consommateur all :
   * `converted_data.csv` : convertit les sépareteurs du fichier ';' en ':'
     * `lv_all.csv` ; récupére l'ID de la station, sa capacité et sa consommation.
       * `lv_all_somme.csv` : récupére l'ID de la station, la somme de la capacité et la consommation.
         * `lv_max_10.csv` : Trie les données par consommation, les 10 plus grandes consommations.
           * `lv_min_10.csv` : Trie les données par consommation, les 10 plus faibles consommations.

  ## Aperçu d'une éxécution en cours...

  <img width="658" alt="Capture d’écran 2024-12-15 à 21 10 56" src="https://github.com/user-attachments/assets/877c30c4-2260-4f36-90d4-984358581a76" />

  
  ## Aperçu de la fonction d'affichage

  <img width="1157" alt="Capture d’écran 2024-12-15 à 21 12 59" src="https://github.com/user-attachments/assets/2821cf3e-56d2-4508-a97c-b52033278bdb" />

  ## Sources :
  
  - Vidéos youtube.
  - Site internet concernant la partie shell et C.
  - TD et CM pour les différentes fonctions des traitements tels que les AVL, les différentes rotations, Shell...
  




  

  

   

  

