#include <stdio.h>
#include <stdlib.h>
#include "avl.h"

// Retourne le maximum entre deux entiers
int max(int a, int b) {
    if (a>b) {
        return a;
    }
    else {
        return b;
    }
}

// Retourne la hauteur d'une station
int hauteur(Station* station) {
    if (station == NULL) { 
        return 0;
    }
    else {
        return station->hauteur;
    }
}

// Rotation gauche pour équilibrer un sous-arbre
Station* rotationGauche(Station* y) {
    if (y == NULL || y->fd == NULL) {
        return y;
    }

    Station* x = y->fd;
    Station* T2 = x->fg;

    x->fg = y;
    y->fd = T2;

    y->hauteur = 1 + max(hauteur(y->fg), hauteur(y->fd));
    x->hauteur = 1 + max(hauteur(x->fg), hauteur(x->fd));

    return x;
}

// Rotation droite pour équilibrer un sous-arbre
Station* rotationDroite(Station* x) {
    if (x == NULL || x->fg == NULL) {
        return x;
    }

    Station* y = x->fg;
    Station* T2 = y->fd;

    y->fd = x;
    x->fg = T2;

    x->hauteur = 1 + max(hauteur(x->fg), hauteur(x->fd));
    y->hauteur = 1 + max(hauteur(y->fg), hauteur(y->fd));

    return y;
}

// Retourne le facteur d'équilibre d'un nœud
int equilibrerAVL(Station* station) {
    return (station == NULL) ? 0 : hauteur(station->fg) - hauteur(station->fd);
}

// Insère une station dans l'arbre AVL
Station* inserer(Station* racine, int id, long long capacite, long long somme_conso) {
    if (racine == NULL) {
        // Création d'un nouveau noeud
        Station* nouveau = (Station*)malloc(sizeof(Station));
        if (nouveau == NULL) {
            printf("Erreur d'allocation de mémoire.\n");
            exit(EXIT_FAILURE);
        }
        nouveau->station_id = id;
        nouveau->capacite = capacite;
        nouveau->somme_conso = somme_conso;
        nouveau->fg = NULL;
        nouveau->fd = NULL;
        nouveau->hauteur = 1;
        return nouveau;
    }

    if (racine->station_id == id) {
        // Mise à jour de la capacité uniquement si elle diffère
        if (racine->capacite != capacite) {
            racine->capacite = capacite;
        }
        // Incrémente la consommation totale
        racine->somme_conso += somme_conso;
    } else if (id < racine->station_id) {
        racine->fg = inserer(racine->fg, id, capacite, somme_conso);
    } else {
        racine->fd = inserer(racine->fd, id, capacite, somme_conso);
    }

    // Mise à jour de la hauteur du noeud
    racine->hauteur = 1 + max(hauteur(racine->fg), hauteur(racine->fd));

    // Vérifie et corrige l'équilibre
    int equilibre = equilibrerAVL(racine);

    // Cas déséquilibrés : rotations nécessaires
    if (equilibre > 1) {
        if (id < racine->fg->station_id) {
            return rotationDroite(racine);
        } else {
            racine->fg = rotationGauche(racine->fg);
            return rotationDroite(racine);
        }
    }

    if (equilibre < -1) {
        if (id > racine->fd->station_id) {
            return rotationGauche(racine);
        } else {
            racine->fd = rotationDroite(racine->fd);
            return rotationGauche(racine);
        }
    }

    return racine;
}


// Parcours infixe pour afficher les stations
void parcourinfixe(Station* racine) {
    if (racine == NULL) {
        return;
    }
    parcourinfixe(racine->fg);
    printf("%d:%lld:%lld\n", racine->station_id, racine->capacite, racine->somme_conso);
    parcourinfixe(racine->fd);
}

// Libère la mémoire allouée pour l'arbre
void libererMemoire(Station* racine) {
    if (racine != NULL) {
        libererMemoire(racine->fg);
        libererMemoire(racine->fd);
        free(racine);
    }
}