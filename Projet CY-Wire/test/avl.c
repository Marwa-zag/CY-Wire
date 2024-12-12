#include <stdio.h>
#include <stdlib.h>
#include "avl.h"

int max(int a, int b) {
    if (a>b) {
        return a;
    }
    else {
        return b;
    }
}

int hauteur(Station* station) {
    if (station == NULL) { 
        return 0;
    }
    else {
        return station->hauteur;
    }
}

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

int equilibrerAVL(Station* station) {
    return (station == NULL) ? 0 : hauteur(station->fg) - hauteur(station->fd);
}

Station* inserer(Station* racine, int id, float capacite, float somme_conso) {
     if (racine == NULL) {
        //création d'un noeud racine sans sous-arbre gauche et droit et return de la racine
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

    // Si il y a deja une racine existante:
    if (racine->station_id == id) {
        racine->somme_conso += somme_conso;
    } else {
        if (racine->station_id > id) {
            racine->fg = insertion(racine->fg, id, capacite, somme_conso);
        } else {
            racine->fd = insertion(racine->fd, id, capacite, somme_conso);
        }

        racine->hauteur = 1 + max(hauteur(racine->fg), hauteur(racine->fd));

        int equilibre = equilibrerAVL(racine);

        if (equilibre > 1) {
            if (id < racine->station_id) {
                return rotationDroite(racine);
            } else {
                racine->fg = rotationGauche(racine->fg);
                return rotationDroite(racine);
            }
        }

        if (equilibre < -1) {
            if (id > racine->station_id) {
                return rotationGauche(racine);
            } else {
                racine->fd = rotationDroite(racine->fd);
                return rotationGauche(racine);
            }
        }
    }

    return racine;
}

void parcourinfixe(Station* racine) {
    if (racine == NULL) {
        return;
    }
    
    parcourinfixe(racine->fg);
    printf("%d:%f:%f\n", racine->station_id, racine->capacite, racine->somme_conso);
    parcourinfixe(racine->fd);
}

void libererMemoire(Station* racine) {
    if (racine != NULL) {
        libererMemoire(racine->fg);
        libererMemoire(racine->fd);
        free(racine);
    }
}

