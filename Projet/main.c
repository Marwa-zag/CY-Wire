#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "avl.h"


//Fonction principale
int main(int argc, char* argv[]){
    FILE* fichier = fopen(argv[1], "r"); //lecture seule
    if(fichier == NULL){
        perror("Erreur lors de l'ouverture du fichier d'entrée");
        return 1;
    }

    noeud* racine = NULL;
    //creation de la racine à faire!

    //On parcourt chaque ligne du fichier temporaire créer par le script shell
     while (fgets(line, sizeof(line), file)) {
        int station_id;
        long capacite, somme_conso = 0;

        // Lecture des colonnes nécessaires
        if (sscanf(line, "%d:%ld:%ld", &station_id, &capacite, &somme_conso) !=3) {
            fprintf(stderr, "Erreur de lecture de la ligne : %s\n", ligne);
            continue;
        }

        racine = insertion(racine, station_id, capacite, somme_conso);
    }

    parcourinfixe(racine);

    fclose(file);
    libererMemoire(racine);
}

