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
