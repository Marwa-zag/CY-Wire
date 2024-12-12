#!/bin/bash

#Nom des arguments
fichier_dat="$1" # Nom du fichier source
type_station=$2 # Type de station (hvb, hva ou lv)
type_consommateur=$3 # Type de consommateur (comp, indiv ou all)
id_centrale="${4:-}" # Si le numéro de centrale est fourni, sinon vide
output_file_name="${type_station}_${type_consommateur}${id_centrale:+_$id_centrale}.csv" # Nom du fichier de sortie généré en fonction des types spécifiés

#- Dossisers utilisés
temp="./temp"   # Dossier temporaire pour les fichiers intermédiaire
graphs="./graphs"  # Dossier pour stocker les graphiques générés

# Gestion de l'option d'aide (-h)
if [[ "$1" == "-h" ]]; then
    # Affichage de l'aide si le fichier existe
    if [[ -f "aide.txt" ]]; then
        cat aide.txt
        echo " " #Saut à la ligne suivante
        exit 0
    else
        # Message d'erreur si le fichier d'aide est introuvable
        echo "Erreur : Le fichier d'aide (aide.txt) est introuvable."
        exit 1
    fi
fi

#Verification de l'existence du dossier temp
if [ ! -d "$temp" ]; then
    echo "Le dossier temp n'existe pas, creation en cours..."
    mkdir -p "$temp"
#Vidage du dossier temp 
else
    echo "Le dossier temporaire existe. Vidage en cours..."
    rm -rf "$temp"/*
    echo "Le dossier a été vidé avec succès."
fi

#Verification de l'existence du dossier images
if [ ! -d "$graphs" ]; then
    echo "Le dossier de graphiques n'existe pas, creation en cours..."
    mkdir -p "$graphs"
    echo "Le dossier de graphiques a été créer avec succès."
fi

# Verification de l'existence du fichier CSV
if [ ! -f "$fichier_dat" ]; then
    echo "Erreur : Le fichier CSV specifie n'existe pas ($fichier_dat)."
    exit 1
fi

# Vérification que l'ID de la centrale est valide (1 à 5)
if [[ -n "$id_centrale" && ! "$id_centrale" =~ ^[1-5]$ ]]; then
    echo "Erreur : Il y a seulment 5 centrale. L'identifiant de la centrale doit être un nombre entre 1 et 5."
    exit 1
fi


# Verification du type de station
if [[ "$type_station" != "hvb" && "$type_station" != "hva" && "$type_station" != "lv" ]]; then
    echo "Erreur : Type de station invalide ($type_station)."
    echo "Les types valides sont : hvb, hva, lv."
    exit 1
fi

# Verification du type de consommateur
if [[ "$type_consommateur" != "comp" && "$type_consommateur" != "indiv" && "$type_consommateur" != "all" ]]; then
    echo "Erreur : Type de consommateur invalide ($type_consommateur)."
    echo "Les types valides sont : comp, indiv, all."
    exit 1
fi

# Verification des combinaisons interdites
if [[ "$type_station" == "hvb" && ( "$type_consommateur" == "all" || "$type_consommateur" == "indiv" ) ]]; then
    echo "Erreur : La combinaison hvb avec all ou indiv est interdite. La seule combinaison possible est comp."
    exit 1
fi

if [[ "$type_station" == "hva" && ( "$type_consommateur" == "all" || "$type_consommateur" == "indiv" ) ]]; then
    echo "Erreur : La combinaison hva avec all ou indiv est interdite. La seule combinaison possible est comp."
    exit 1
fi

# Repertoire contenant les fichiers C et le Makefile
EXECUTABLE="./progC"

# Verification du repertoire contenant le Makefile
if [ ! -d "$EXECUTABLE" ]; then
    echo "Erreur : Le repertoire $EXECUTABLE est introuvable."
    exit 1
fi

# Compilation via Makefile
echo "Compilation de c-wire avec Makefile dans $EXECUTABLE..."
cd "$EXECUTABLE" || exit 1
make
if [ $? -ne 0 ]; then
    echo "Erreur : echec de la compilation avec Makefile."
    exit 1
fi
echo "Compilation reussie."

# Retour au répertoire précédent
cd - >/dev/null || exit 1

#  Début du traitement des données 
debut_temps=$(date +%s) # Calcul de la duree du traitement

# Traitement des données en fonction du type de station et de consommateur
echo "Traitement en cours pour le type de station '$type_station' et consommateur '$type_consommateur'..."

case $type_station in
    hvb)
        if [[ "$type_consommateur" == "comp" ]]; then
            # Convertir les ; en : dans le fichier source
            sed 's/;/:/g' "$fichier_dat" > temp/converted_data.csv

            # Appliquer le filtre avec le séparateur et filtrage optionnel par centrale
            awk -F':' -v central="$id_centrale" '
                BEGIN { FS=":"; OFS=":" }
                (central == "" || $1 == central) && $2 != "-" && $3 == "-" && $4 == "-" && $6 == "-" {
                    gsub(/-/, "0", $7);
                    gsub(/-/, "0", $8);
                    print $2, $7, $8
                }' temp/converted_data.csv > temp/hvb_comp${id_centrale:+_$id_centrale}.csv

            echo "Résultat intermédiaire : temp/hvb_comp${id_centrale:+_$id_centrale}.csv"
            "$EXECUTABLE/c-wire" temp/hvb_comp${id_centrale:+_$id_centrale}.csv > temp/hvb_comp_result${id_centrale:+_$id_centrale}.csv
            echo "Résultat final : temp/hvb_comp_result${id_centrale:+_$id_centrale}.csv"
        fi
        ;;
    hva)
        if [[ "$type_consommateur" == "comp" ]]; then
            sed 's/;/:/g' "$fichier_dat" > temp/converted_data.csv

            # Appliquer le filtre avec le séparateur et filtrage optionnel par centrale
            awk -F':' -v central="$id_centrale" '
                BEGIN { FS=":"; OFS=":" }
                (central == "" || $1 == central) && $3 != "-" && $6 == "-" {
                    gsub(/-/, "0", $7);
                    gsub(/-/, "0", $8);
                    print $3, $7, $8
                }' temp/converted_data.csv > temp/hva_comp${id_centrale:+_$id_centrale}.csv

            echo "Résultat intermédiaire : temp/hva_comp${id_centrale:+_$id_centrale}.csv"
            "$EXECUTABLE/c-wire" temp/hva_comp${id_centrale:+_$id_centrale}.csv > temp/hva_comp_result${id_centrale:+_$id_centrale}.csv
            echo "Résultat final : temp/hva_comp_result${id_centrale:+_$id_centrale}.csv"
        fi
        ;;
    lv)
        case $type_consommateur in
            comp)
                sed 's/;/:/g' "$fichier_dat" > temp/converted_data.csv

                # Appliquer le filtre avec le séparateur et filtrage optionnel par centrale
                awk -F':' -v central="$id_centrale" '
                    BEGIN { FS=":"; OFS=":" }
                    (central == "" || $1 == central) && $4 != "-" && $6 == "-" {
                        gsub(/-/, "0", $7);
                        gsub(/-/, "0", $8);
                        print $4, $7, $8
                    }' temp/converted_data.csv > temp/lv_comp${id_centrale:+_$id_centrale}.csv

                echo "Résultat intermédiaire : temp/lv_comp${id_centrale:+_$id_centrale}.csv"
                "$EXECUTABLE/c-wire" temp/lv_comp${id_centrale:+_$id_centrale}.csv > temp/lv_comp_result${id_centrale:+_$id_centrale}.csv
                echo "Résultat final : temp/lv_comp_result${id_centrale:+_$id_centrale}.csv"
                ;;
            indiv)
                sed 's/;/:/g' "$fichier_dat" > temp/converted_data.csv

                # Appliquer le filtre avec le séparateur et filtrage optionnel par centrale
                awk -F':' -v central="$id_centrale" '
                    BEGIN { FS=":"; OFS=":" }
                    (central == "" || $1 == central) && $4 != "-" && $5 == "-" {
                        gsub(/-/, "0", $7);
                        gsub(/-/, "0", $8);
                        print $4, $7, $8
                    }' temp/converted_data.csv > temp/lv_indiv${id_centrale:+_$id_centrale}.csv

                echo "Résultat intermédiaire : temp/lv_indiv${id_centrale:+_$id_centrale}.csv"
                "$EXECUTABLE/c-wire" temp/lv_indiv${id_centrale:+_$id_centrale}.csv > temp/lv_indiv_result${id_centrale:+_$id_centrale}.csv
                echo "Résultat final : temp/lv_indiv_result${id_centrale:+_$id_centrale}.csv"
                ;;
            all)
                sed 's/;/:/g' "$fichier_dat" > temp/converted_data.csv

                # Filtrer les données pour ignorer l'en-tête et les lignes mal formées
                awk -F':' -v central="$id_centrale" '
                    BEGIN { FS=":"; OFS=":" }
                    NR > 1 && (central == "" || $1 == central) && $4 != "-" && $7 != "" && $8 != "" {
                        gsub(/-/, "0", $7);
                        gsub(/-/, "0", $8);
                        print $4, $7, $8
                    }' temp/converted_data.csv > temp/lv_all${id_centrale:+_$id_centrale}.csv

                echo "Résultat intermédiaire : temp/lv_all${id_centrale:+_$id_centrale}.csv"
                "$EXECUTABLE/c-wire" temp/lv_all${id_centrale:+_$id_centrale}.csv > temp/lv_all_result${id_centrale:+_$id_centrale}.csv
                echo "Résultat final : temp/lv_all_result${id_centrale:+_$id_centrale}.csv"
                ;;
        esac
        ;;
    *)
        echo "Erreur : Type de station invalide."
        cat aide.txt
        ;;
esac

# Fin du traitement
fin_temps=$(date +%s)
duree=$((fin_temps - debut_temps)) # Calcul de la duree du traitement
echo "Temps d'execution du traitement : $duree secondes"


# Vérification : Si le fichier est vide
if [ ! -s "$temp/$output_file_name" ]; then
    echo "Attention : Le fichier $output_file_name est vide. Verifiez vos colonnes ou les donnees sources."
    exit 1
fi

# Confirmation de la génération du fichier 
echo "Le fichier $temp/$output_file_name a ete genere avec succès dans le dossier temp."
