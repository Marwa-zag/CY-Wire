#!/bin/bash
#NE PAS OUBLIER DE RAJOUTER LE CODE DE L'eXeCUTABLE

#Nom des arguments
fichier_dat="$1"
type_station=$2
type_consommateur=$3
output_file="${type_station}_${type_consommateur}.csv"  # Output file name

#Nom des dossiers
temp="./temp"
graphs="./graphs"

#Verification de l'existence du dossier temp
if [ ! -d "$temp" ]; then
    echo "Le dossier temp n'existe pas, creation en cours..."
    mkdir -p "$temp"
#Vidage du dossier temp (PS NE PAS OUBLIER DE RETIRER LES # DEVANT POUR VIDER TEMP)
#else
    #echo "Le dossier temporaire existe. Vidage en cours..."
    #rm -rf "$temp"/*
fi

#Verification de l'existence du dossier images
if [ ! -d "$graphs" ]; then
    echo "Le dossier de graphiques n'existe pas, creation en cours..."
    mkdir -p "$graphs"
fi

# Verification de l'existence du fichier CSV
if [ ! -f "$fichier_dat" ]; then
    echo "Erreur : Le fichier CSV specifie n'existe pas ($fichier_dat)."
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
    echo "Erreur : La combinaison hvb avec all ou indiv est interdite."
    exit 1
fi

if [[ "$type_station" == "hva" && ( "$type_consommateur" == "all" || "$type_consommateur" == "indiv" ) ]]; then
    echo "Erreur : La combinaison hva avec all ou indiv est interdite."
    exit 1
fi

# Repertoire contenant les fichiers C et le Makefile
EXECUTABLE="./progc"

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
cd - >/dev/null || exit 1

debut_temps=$(date +%s)

# Executer en fonction du type de station et de consommateur
echo "Traitement en cours pour le type de station '$type_station' et consommateur '$type_consommateur'..."

case $type_station in
    hvb)
        if [[ "$type_consommateur" == "comp" ]]; then
            awk -F';' '
                $2 != "-" && $3 == "-" && $4 == "-" && $6 == "-" {
                    gsub(/-/, "0", $7); gsub(/-/, "0", $8);
                    print $2 ";" $7 ";" $8
                }' "$fichier_dat" > temp/hvb_comp.csv
            echo "Résultat intermédiaire : temp/hvb_comp.csv"
            "$EXECUTABLE/c-wire" temp/hvb_comp.csv > temp/hvb_result.csv
            echo "Résultat final : temp/hvb_result.csv"
        fi
        ;;
    hva)
        if [[ "$type_consommateur" == "comp" ]]; then
            awk -F';' '
                $3 != "-"  && $6 == "-" {
                    gsub(/-/, "0", $7); gsub(/-/, "0", $8);
                    print $3 ";" $7 ";" $8
                }' "$fichier_dat" > temp/hva_comp.csv
            echo "Résultat intermédiaire : temp/hva_comp.csv"
            "$EXECUTABLE/c-wire" temp/hva_comp.csv > temp/hva_resultat.csv
        fi
        ;;
    lv)
        case $type_consommateur in
            comp)
                awk -F';' '
                    $4 != "-"  && $6 == "-" {
                        gsub(/-/, "0", $7); gsub(/-/, "0", $8);
                        print $4 ";" $7 ";" $8
                    }' "$fichier_dat" > temp/lv_comp.csv
                echo "Résultat intermédiaire : temp/lv_comp.csv"
                "$EXECUTABLE/c-wire" temp/lv_comp.csv > temp/lv_resultat.csv
                ;;
            indiv)
                awk -F';' '
                    $4 != "-" && $5 == "-" {
                        gsub(/-/, "0", $7); gsub(/-/, "0", $8);
                        print $4 ";" $7 ";" $8
                    }' "$fichier_dat" > temp/lv_indiv.csv
                echo "Résultat intermédiaire : temp/lv_indiv.csv"
                "$EXECUTABLE/c-wire" temp/lv_indiv.csv > temp/lv_indiv_resultat.csv
                ;;
            all)
                awk -F';' '
                    $4 != "-"  {
                        gsub(/-/, "0", $7); gsub(/-/, "0", $8);
                        print $4 ";" $7 ";" $8
                    }' "$fichier_dat" > temp/lv_all.csv
                echo "Résultat intermédiaire : temp/lv_all.csv"
                "$EXECUTABLE/c-wire" temp/lv_all.csv > temp/lv_all_resultat.csv
                ;;
        esac
        ;;
    *)
        echo "Erreur : Type de station invalide."
        show_help
        ;;
esac

fin_temps=$(date +%s)
duree=$((fin_temps - debut_temps)) # Calcul de la duree du traitement
echo "Temps d'execution du traitement : $duree secondes"

# Verification : Si le fichier est vide
if [ ! -s "$temp/$output_file" ]; then
    echo "Attention : Le fichier $output_file est vide. Verifiez vos colonnes ou les donnees sources."
    exit 1
fi

# Message de confirmation
echo "Le fichier $temp/$output_file a ete genere avec succès dans le dossier temp." 