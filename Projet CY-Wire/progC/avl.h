#ifndef AVL_H
#define AVL_H

// structure permettant de contenir les informations d'une station

typedef struct Station {
    int station_id;  // Identifiant de la station  
    double capacite; // Capacité de la station en MW 
    double somme_conso; // Somme des valeurs de consommation 
    struct Station* fg; // Pointeur vers le sous-arbre gauche
    struct Station* fd; // Pointeur vers le sous-arbre droit
    int hauteur; // Hauteur du nœud pour l'équilibre de l'AVL
} Station;


int hauteur(Station* station); 
Station* rotationGauche(Station* y);
Station* rotationDroite(Station* x);
int equilibrerAVL(Station* station);
Station* inserer(Station* racine, int id, float capacite, float somme_conso);
void parcourinfixe(Station* racine); // Fonction pour parcourir l'arbre en ordre infixe (gauche -> racine -> droite)
void libererMemoire(Station* racine);

#endif
