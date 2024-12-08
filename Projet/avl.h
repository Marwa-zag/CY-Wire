#ifndef AVL_H
#define AVL_H

// structure permettant de contenir les informations d'une station

typedef struct Station {
    int station_id;              
    double capacite; // Capacité de la station en MW 
    double somme_consommateur; // Somme des valeurs de consommation 
    struct Station* fg; // Pointeur vers le sous-arbre gauche
    struct Station* fd; // Pointeur vers le sous-arbre droit
    int hauteur; // Hauteur du nœud pour l'équilibre de l'AVL
} Station;


int hauteur(Station* station); 
Station* rotationGauche(Station* y);
Station* rotationDroite(Station* x);
#endif

