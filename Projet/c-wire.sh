#!/bin/bash
#NE PAS OUBLIER DE RAJOUTER LE CODE DE L'ÉXÉCUTABLE

#Nom des arguments
fichier_dat="$1"
type_station=$2
type_consommateur=$3
output_file="${type_station}_${type_consommateur}.csv"  # Output file name

#Nom des dossiers
temp="./temp"
graphs="./graphs"

#Vérification de l'existence du dossier temp
if [ ! -d "$temp" ]; then
    echo "Le dossier temp n'existe pas, création en cours..."
    mkdir -p "$temp"
#Vidage du dossier temp
else
    echo "Le dossier temporaire existe. Vidage en cours..."
    rm -rf "$temp"/*
fi

#Vérification de l'existence du dossier images
if [ ! -d "$graphs" ]; then
    echo "Le dossier de graphiques n'existe pas, création en cours..."
    mkdir -p "$graphs"
fi

# Vérification de l'existence du fichier CSV
if [ ! -f "$fichier_dat" ]; then
    echo "Erreur : Le fichier CSV spécifié n'existe pas ($fichier_dat)."
    exit 1
fi
# Vérification du type de station
if [[ "$type_station" != "hvb" && "$type_station" != "hva" && "$type_station" != "lv" ]]; then
    echo "Erreur : Type de station invalide ($type_station)."
    echo "Les types valides sont : hvb, hva, lv."
    exit 1
fi

# Vérification du type de consommateur
if [[ "$type_consommateur" != "comp" && "$type_consommateur" != "indiv" && "$type_consommateur" != "all" ]]; then
    echo "Erreur : Type de consommateur invalide ($type_consommateur)."
    echo "Les types valides sont : comp, indiv, all."
    exit 1
fi

# Vérification des combinaisons interdites
if [[ "$type_station" == "hvb" && ( "$type_consommateur" == "all" || "$type_consommateur" == "indiv" ) ]]; then
    echo "Erreur : La combinaison hvb avec all ou indiv est interdite."
    exit 1
fi

if [[ "$type_station" == "hva" && ( "$type_consommateur" == "all" || "$type_consommateur" == "indiv" ) ]]; then
    echo "Erreur : La combinaison hva avec all ou indiv est interdite."
    exit 1
fi

# Définir la colonne en fonction du type de station
case "$type_station" in
  "hvb") col_station=2 ;;  # Colonne pour "HV-B Station"
  "hva") col_station=3 ;;  # Colonne pour "HV-A Station"
  "lv") col_station=4 ;;   # Colonne pour "LV Station"
  *) echo "Type de station inconnu : $type_station"; exit 1 ;;
esac

# Débogage : Afficher un aperçu des données
echo "Aperçu des 10 premières lignes du fichier source :"
head "$fichier_dat"

# Extraction des colonnes nécessaires : ID de la station, Capacité, Consommation
awk -F';' -v col="$col_station" '
BEGIN {
    OFS = ","  # Utilisation de la virgule comme séparateur dans le fichier CSV généré
    print "ID Station", "Capacité", "Consommation"  # En-tête du fichier CSV
}
{
    # Vérifie si la colonne est valide et non vide
    if ($col != "-" && $col != "" && $col ~ /^[0-9]+$/) {
        print $col, $7, $8  # ID Station, Capacité, Consommation
    }
}' "$fichier_dat" > "$temp/$output_file"

# Vérification : Si le fichier est vide
if [ ! -s "$temp/$output_file" ]; then
    echo "Attention : Le fichier $output_file est vide. Vérifiez vos colonnes ou les données sources."
    exit 1
fi

# Message de confirmation
echo "Le fichier $temp/$output_file a été généré avec succès dans le dossier temp."