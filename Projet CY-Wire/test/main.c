#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "avl.h"


//Fonction principale
int main(int argc, char* argv[]){
     if (argc != 2) {
        fprintf(stderr, "Usage: %s <fichier_donnees>\n", argv[0]);
        return 1;
    }

    FILE* fichier = fopen(argv[1], "r"); //lecture seule
    if(fichier == NULL){
        perror("Erreur lors de l'ouverture du fichier d'entrée");
        return 1;
    }

    Station* racine = NULL;

    char ligne[1500];
    //On parcourt chaque ligne du fichier temporaire créer par le script shell
     while (fgets(ligne, sizeof(ligne), fichier)) {
        int station_id;
        long capacite, somme_conso = 0;

        // Lecture des colonnes nécessaires
        if (sscanf(ligne, "%d:%ld:%ld", &station_id, &capacite, &somme_conso) !=3) {
            fprintf(stderr, "Erreur de lecture de la ligne : %s\n", ligne);
            continue;
        }

        racine = insertion(racine, station_id, capacite, somme_conso);
    }

    parcourinfixe(racine);

    fclose(fichier);
    libererMemoire(racine);
}

