#ifndef AVL_H
#define AVL_H


// structure permettant de contenir les informations d'une station

typedef struct Station {
    int station_id;           // Identifiant de la station  
    unsigned long long capacite;       // Capacité en kWh 
    unsigned long long somme_conso;    // Somme des valeurs de consommation 
    struct Station* fg;       // Sous-arbre gauche
    struct Station* fd;       // Sous-arbre droit
    unsigned char hauteur;              // Hauteur pour l'équilibre
} Station;


unsigned char hauteur(Station* station); 
Station* rotationGauche(Station* y);
Station* rotationDroite(Station* x);
int equilibrerAVL(Station* station);
Station* inserer(Station* racine, int id, unsigned long long capacite, unsigned long long somme_conso);
void parcourinfixe(Station* racine); // Fonction pour parcourir l'arbre en ordre infixe (gauche -> racine -> droite)
void libererMemoire(Station* racine);

#endif
