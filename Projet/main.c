#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "avl.h"



int main(int argc, char* argv[]){
    FILE* fichier = fopen(argv[1], "r"); //lecture seule

    if (!fichier) {
        printf("Erreur d'ouverture du fichier");
        exit(EXIT_FAILURE);
    }
    //creation de la racine à faire!

    //On parcourt chaque ligne du fichier temporaire créer par le script shell
     while (fgets(line, sizeof(line), file)) {
        int station_id;
        long capacite, somme_conso = 0;

        // Lecture des colonnes nécessaires
        if (sscanf(line, "%d:%ld:%ld", &station_id, &capacite, &somme_conso) >= 2) {
            //ici on va insérer une nouvelle station (on appelera la fonction inserer)à faire!
        }
    }

    fclose(file);
}

