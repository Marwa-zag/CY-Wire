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
#Vidage du dossier temp (PS NE PAS OUBLIER DE RETIRER LES # DEVANT POUR VIDER TEMP)
#else
    #echo "Le dossier temporaire existe. Vidage en cours..."
    #rm -rf "$temp"/*
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

#Nom de l'exécutable C
executable="projet"

#Vérification de la présence de l'exécutable
if [ ! -x "$executable" ]; then
   echo "Compilation en cours..."
   #Compilation du programme C
   make build
   #Vérification du déroulement de la compilation
   if [ $? -eq 0 ]; then
       echo "Compilation réussie. L'exécutable $executable a été créé."
   else
       echo "Erreur lors de la compilation."
       exit 1
   fi
   # Vérifier les fichiers générés
   for type in hvb hva lv; do
   file="tmp/resultat_${type}.csv"
   if [ -f "$file" ]; then
    echo "Fichier généré : $file"
    else
      echo "Erreur : Le fichier $file n'a pas été généré."
    fi
done
else
    echo "L'exécutable $executable existe déjà."
fi
debut_temps=$(date +%s)

# Exécuter en fonction du type de station et de consommateur
case "$type_station" in
  "hvb")
    case "$type_consommateur" in
      "comp")
        awk -F';' '
          $2 != "-" && $3 == "-" && $4 == "-" && $6 == "-" {
              gsub(/-/, "0", $7); gsub(/-/, "0", $8);
              print $2, $7, $8
          }' "$fichier_dat" > "$temp/hvb_comp.dat"
        echo "Résultat intermédiaire : $temp/hvb_comp.dat"
        "./projet" "$temp/hvb_comp.dat" > "$temp/hvb_result.dat"
        echo "Résultat final : $temp/hvb_result.dat"
        ;;
      *)
        echo "Erreur : Type de consommateur invalide pour HVB."
        exit 1
        ;;
    esac
    ;;
  "hva")
    case "$type_consommateur" in
      "comp")
        awk -F';' '
          $3 != "-" && $6 == "-" {
              gsub(/-/, "0", $7); gsub(/-/, "0", $8);
              print $3, $7, $8
          }' "$fichier_dat" > "$temp/hva_comp.dat"
        echo "Résultat intermédiaire : $temp/hva_comp.dat"
        "./projet" "$temp/hva_comp.dat" > "$temp/hva_result.dat"
        echo "Résultat final : $temp/hva_result.dat"
        ;;
      *)
        echo "Erreur : Type de consommateur invalide pour HVA."
        exit 1
        ;;
    esac
    ;;
  "lv")
    case "$type_consommateur" in
      "comp")
        awk -F';' '
          $4 != "-" && $6 == "-" {
              gsub(/-/, "0", $7); gsub(/-/, "0", $8);
              print $4, $7, $8
          }' "$fichier_dat" > "$temp/lv_comp.dat"
        echo "Résultat intermédiaire : $temp/lv_comp.dat"
        "./projet" "$temp/lv_comp.dat" > "$temp/lv_result.dat"
        echo "Résultat final : $temp/lv_result.dat"
        ;;
      "indiv")
        awk -F';' '
          $4 != "-" && $5 == "-" {
              gsub(/-/, "0", $7); gsub(/-/, "0", $8);
              print $4, $7, $8
          }' "$fichier_dat" > "$temp/lv_indiv.dat"
        echo "Résultat intermédiaire : $temp/lv_indiv.dat"
        "./projet" "$temp/lv_indiv.dat" > "$temp/lv_indiv_result.dat"
        echo "Résultat final : $temp/lv_indiv_result.dat"
        ;;
      "all")
        awk -F';' '
          $4 != "-" {
              gsub(/-/, "0", $7); gsub(/-/, "0", $8);
              print $4, $7, $8
          }' "$fichier_dat" > "$temp/lv_all.dat"
        echo "Résultat intermédiaire : $temp/lv_all.dat"
        "./projet" "$temp/lv_all.dat" > "$temp/lv_all_result.dat"
        echo "Résultat final : $temp/lv_all_result.dat"
        ;;
      *)
        echo "Erreur : Type de consommateur invalide pour LV."
        exit 1
        ;;
    esac
    ;;
  *)
    echo "Erreur : Type de station invalide."
    exit 1
    ;;
esac

fin_temps=$(date +%s)
duree=$((fin_temps - debut_temps)) # Calcul de la durée du traitement
echo "Temps d'exécution du traitement : $duree secondes"

# Vérification : Si le fichier est vide
if [ ! -s "$temp/$output_file" ]; then
    echo "Attention : Le fichier $output_file est vide. Vérifiez vos colonnes ou les données sources."
    exit 1
fi

# Message de confirmation
echo "Le fichier $temp/$output_file a été généré avec succès dans le dossier temp."
