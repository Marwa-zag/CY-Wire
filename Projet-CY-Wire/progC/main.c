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
        // Supprimer les espaces ou caractères indésirables
        ligne[strcspn(ligne, "\n")] = 0; // Enlever le caractère de saut de ligne
        
        // Ignorer les lignes d'en-tête ou mal formées
        if (strstr(ligne, "Station") || strcmp(ligne, "") == 0 || strstr(ligne, "::")) {
            continue;
        }
        
        int station_id;
        unsigned long long capacite, somme_conso;
        
        // Lecture des colonnes nécessaires
        if (sscanf(ligne, "%d:%llu:%llu", &station_id, &capacite, &somme_conso) != 3) {
            fprintf(stderr, "Erreur de lecture de la ligne : %s\n", ligne);
            continue;
        }

        racine = inserer(racine, station_id, capacite, somme_conso);
    }


    parcourinfixe(racine);

    fclose(fichier);
    libererMemoire(racine);
}