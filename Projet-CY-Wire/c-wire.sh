#!/bin/bash

#Nom des arguments
fichier_dat="$1" # Nom du fichier source
type_station=$2 # Type de station (hvb, hva ou lv)
type_consommateur=$3 # Type de consommateur (comp, indiv ou all)
id_centrale="${4:-}" # Si le numéro de centrale est fourni, sinon vide
output_file_name="${type_station}_${type_consommateur}${id_centrale:+_$id_centrale}.csv" # Nom du fichier de sortie généré en fonction des types spécifiés

# Chemin du fichier d'aide
fichier_aide="aide.txt"

# Fonction pour afficher l'aide
afficher_aide() {
    if [[ -f "$fichier_aide" ]]; then
        cat "$fichier_aide"
    else
        echo "Erreur : Le fichier d'aide ($fichier_aide) est introuvable."
    fi
}

# Vérification si l'utilisateur demande l'aide
if [[ "$1" == "-h" ]]; then
    afficher_aide
    echo " "
    exit 0
fi


# Vérification que le fichier est dans le dossier data
dossier_data="data"
if [[ "$fichier_dat" != "$dossier_data/"* ]]; then
    echo "Erreur : Le fichier doit être situé dans le dossier '$dossier_data'."
    afficher_aide
    echo " "
    exit 1
fi

# Vérification de l'existence du fichier
if [ ! -f "$fichier_dat" ]; then
    echo "Erreur : Le fichier CSV spécifié n'existe pas dans le dossier '$dossier_data' ($fichier_dat)."
    afficher_aide
    echo " "
    exit 1
fi

#- Dossisers utilisés
temp="./temp"   # Dossier temporaire pour les fichiers intermédiaire
graphs="./graphs"  # Dossier pour stocker les graphiques générés
tests="./tests" # Dossier pour stocker les fichiers finaux


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

# Vérification que l'ID de la centrale est valide (1 à 5)
if [[ -n "$id_centrale" && ! "$id_centrale" =~ ^[1-5]$ ]]; then
    echo "Erreur : Il y a seulment 5 centrale. L'identifiant de la centrale doit être un nombre entre 1 et 5."
    afficher_aide
    echo " "
    exit 1
fi


# Verification du type de station
if [[ "$type_station" != "hvb" && "$type_station" != "hva" && "$type_station" != "lv" ]]; then
    echo "Erreur : Type de station invalide ($type_station)."
    echo "Les types valides sont : hvb, hva, lv."
    afficher_aide
    echo " "
    exit 1
fi

# Verification du type de consommateur
if [[ "$type_consommateur" != "comp" && "$type_consommateur" != "indiv" && "$type_consommateur" != "all" ]]; then
    echo "Erreur : Type de consommateur invalide ($type_consommateur)."
    echo "Les types valides sont : comp, indiv, all."
    afficher_aide
    echo " "
    exit 1
fi

# Verification des combinaisons interdites
if [[ "$type_station" == "hvb" && ( "$type_consommateur" == "all" || "$type_consommateur" == "indiv" ) ]]; then
    echo "Erreur : La combinaison hvb avec all ou indiv est interdite. La seule combinaison possible est comp."
    afficher_aide
    echo " "
    exit 1
fi

if [[ "$type_station" == "hva" && ( "$type_consommateur" == "all" || "$type_consommateur" == "indiv" ) ]]; then
    echo "Erreur : La combinaison hva avec all ou indiv est interdite. La seule combinaison possible est comp."
    afficher_aide
    echo " "
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
            # Convertit les ; en : dans le fichier source
            sed 's/;/:/g' "$fichier_dat" > temp/converted_data.csv

            # Applique le filtre avec le séparateur et filtrage optionnel par centrale
            awk -F':' -v central="$id_centrale" '
                BEGIN { FS=":"; OFS=":" }
                (central == "" || $1 == central) && $2 != "-" && $3 == "-" && $4 == "-" && $6 == "-" {
                    gsub(/-/, "0", $7); 
                    gsub(/-/, "0", $8);
                    print $2, $7, $8
                }' temp/converted_data.csv  | sort -t: -k2,2n > temp/hvb_comp${id_centrale:+_$id_centrale}.csv

                echo "Résultat intermédiaire : temp/hvb_comp${id_centrale:+_$id_centrale}.csv"

             # Ajout de l'entête au fichier final
            {
                echo "Station HVB:Capacite:Consommation(entreprises)";
                "$EXECUTABLE/c-wire" temp/hvb_comp${id_centrale:+_$id_centrale}.csv | sort -t: -k2,2n;
            } > tests/hvb_comp_somme${id_centrale:+_$id_centrale}.csv
            echo "Résultat final : tests/hvb_comp_somme${id_centrale:+_$id_centrale}.csv"
        fi
        ;;
    hva)
        if [[ "$type_consommateur" == "comp" ]]; then
            sed 's/;/:/g' "$fichier_dat" > temp/converted_data.csv

            # Applique le filtre avec le séparateur et filtrage optionnel par centrale
            awk -F':' -v central="$id_centrale" '
                BEGIN { FS=":"; OFS=":" }
                (central == "" || $1 == central) && $3 != "-" && $6 == "-" {
                    gsub(/-/, "0", $7);
                    gsub(/-/, "0", $8);
                    print $3, $7, $8
                }' temp/converted_data.csv | sort -t: -k2,2n > temp/hva_comp${id_centrale:+_$id_centrale}.csv

                echo "Résultat intermédiaire : temp/hva_comp${id_centrale:+_$id_centrale}.csv"

            # Ajout de l'entête au fichier final
            {
                echo "Station HVA:Capacite:Consommation(entreprises)";
                "$EXECUTABLE/c-wire" temp/hva_comp${id_centrale:+_$id_centrale}.csv | sort -t: -k2,2n;
            } > tests/hva_comp_somme${id_centrale:+_$id_centrale}.csv
            echo "Résultat final : tests/hva_comp_somme${id_centrale:+_$id_centrale}.csv"
        fi
        ;;
    lv)
        case $type_consommateur in
            comp)
                sed 's/;/:/g' "$fichier_dat" > temp/converted_data.csv

                # Applique le filtre avec le séparateur et filtrage optionnel par centrale
                awk -F':' -v central="$id_centrale" '
                    BEGIN { FS=":"; OFS=":" }
                    (central == "" || $1 == central) && $4 != "-" && $6 == "-" {
                        gsub(/-/, "0", $7);
                        gsub(/-/, "0", $8);
                        print $4, $7, $8
                    }' temp/converted_data.csv | sort -t: -k2,2n > temp/lv_comp${id_centrale:+_$id_centrale}.csv

                    echo "Résultat intermédiaire : temp/lv_comp${id_centrale:+_$id_centrale}.csv"

                # Ajout de l'entête au fichier final
                {
                    echo "Station LV:Capacite:Consommation(entreprises)";
                    "$EXECUTABLE/c-wire" temp/lv_comp${id_centrale:+_$id_centrale}.csv | sort -t: -k2,2n;
                } > tests/lv_comp_somme${id_centrale:+_$id_centrale}.csv
                echo "Résultat final : tests/lv_comp_somme${id_centrale:+_$id_centrale}.csv"            
                ;;
            indiv)
                sed 's/;/:/g' "$fichier_dat" > temp/converted_data.csv

                # Applique le filtre avec le séparateur et filtrage optionnel par centrale
                awk -F':' -v central="$id_centrale" '
                    BEGIN { FS=":"; OFS=":" }
                    (central == "" || $1 == central) && $4 != "-" && $5 == "-" {
                        gsub(/-/, "0", $7);
                        gsub(/-/, "0", $8);
                        print $4, $7, $8
                    }' temp/converted_data.csv | sort -t: -k2,2n > temp/lv_indiv${id_centrale:+_$id_centrale}.csv

                    echo "Résultat intermédiaire : temp/lv_indiv${id_centrale:+_$id_centrale}.csv"

                # Ajout de l'entête au fichier final
                {
                    echo "Station LV:Capacite:Consommation(particuliers)";
                    "$EXECUTABLE/c-wire" temp/lv_indiv${id_centrale:+_$id_centrale}.csv | sort -t: -k2,2n;
                } > tests/lv_indiv_somme${id_centrale:+_$id_centrale}.csv
                echo "Résultat final : tests/lv_indiv_somme${id_centrale:+_$id_centrale}.csv"
                ;;
            all)
                sed 's/;/:/g' "$fichier_dat" > temp/converted_data.csv

                # Filtre les données pour ignorer l'en-tête et les lignes mal formées
                awk -F':' -v central="$id_centrale" '
                    BEGIN { FS=":"; OFS=":" }
                    NR > 1 && (central == "" || $1 == central) && $4 != "-" && $7 != "" && $8 != "" {
                        gsub(/-/, "0", $7);
                        gsub(/-/, "0", $8);
                        print $4, $7, $8
                    }' temp/converted_data.csv | sort -t: -k2,2n > temp/lv_all${id_centrale:+_$id_centrale}.csv

                    echo "Résultat intermédiaire : temp/lv_all${id_centrale:+_$id_centrale}.csv"


                # Ajout de l'entête au fichier final
                {
                    echo "Station LV:Capacite:Consommation(tous)";
                    "$EXECUTABLE/c-wire" temp/lv_all${id_centrale:+_$id_centrale}.csv | sort -t: -k2,2n;
                } > tests/lv_all_somme${id_centrale:+_$id_centrale}.csv
                echo "Résultat final : tests/lv_all_somme${id_centrale:+_$id_centrale}.csv"

               # === Traitement supplémentaire pour lv_all_minmax.csv ===

                # calcule la différence (capacité - consommation), puis trie
                awk -F':' -v central="$id_centrale" ' {
                    diff = $2 - $3;
                    printf "%s:%s:%s:%.0f\n", $1, $2, $3, diff;
                }' "$tests/lv_all_somme${id_centrale:+_$id_centrale}.csv" | sort -t: -k4,4n -k1,1n > "$temp/diff_sorted.csv"

                # Sélectionne les 10 postes avec les plus petites différences et les 10 plus grandes, en excluant les doublons
                awk -F':' '!seen[$1]++' "$temp/diff_sorted.csv" | {
                    head -n 10 > "$temp/lv_min_10.csv"
                    tail -n 10 > "$temp/lv_max_10.csv"
                }

                echo "Résultat intermédiaire : temp/diff_sorted.csv${id_centrale:+_$id_centrale}.csv, temp/lv_min_10.csv${id_centrale:+_$id_centrale}.csv, temp/lv_min_10.csv${id_centrale:+_$id_centrale}.csv."

                # Fusionne les résultats dans le fichier final avec entête
                {
                    echo "Min and Max 'capacity-load' extreme nodes";
                    echo "Station LV:Capacite:Consommation";  # Ajouter l'entête
                    cat "$temp/lv_min_10.csv" "$temp/lv_max_10.csv" | awk -F':' '!seen[$1]++' | sort -t: -k4,4n | cut -d: -f1-3;
                } > "$tests/lv_all_minmax${id_centrale:+_$id_centrale}.csv"


                echo "Résultat final : tests/lv_all_minmax${id_centrale:+_$id_centrale}.csv"
                ;;
        esac
        ;;
    *)
        echo "Erreur : Type de station invalide."
        afficher_aide
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
echo "Le fichier $tests/$output_file_name a ete genere avec succès dans le dossier tests."


#  ===================== Bonus =====================


if command -v gnuplot &> /dev/null; then

    if [ "$type_station" == "lv" ] && [ "$type_consommateur" == "all" ]; then

        # Début du traitement graphique
        debut_temps=$(date +%s)

        echo "Création du graphique des 10 postes LV les plus et les 10 moins chargés..."

        gnuplot <<- EOF

            # Configuration de l'image
            set terminal pngcairo enhanced font "Arial,12" size 1200,1000
            set output "$graphs/graphique_lvminmax${id_centrale:+_$id_centrale}.png"

            # Fichier à traiter
            set datafile separator ":"
            datafile = "$tests/lv_all_minmax${id_centrale:+_$id_centrale}.csv"

            # Légende et titre
            set title "lv all minmax : Comparaison de la capacité des stations et de la consommation (surcharge visible)" font "Arial,14"
            set xlabel "ID Stations" font "Arial,10"
            set ylabel "Capacité (kWh)" font "Arial,10"
            set xtics rotate by -90 font "Arial,8"

            # Échelle
            set yrange [0:*]

            # Désactiver l'affichage en notation scientifique
            set format y "%.0f"

            # Mettre la légende des barres à l'extérieur du graphique
            set key outside top center horizontal

            # Style des barres
            set style data histograms
            set style histogram cluster gap 1
            set style fill solid 0.6 border -1  # Réduction de l'opacité
            set boxwidth 0.75

            # Couleurs pour les barres
            MinColor = "#32CD32"  # Vert pour la capacité
            MaxColor = "#FF6347"  # Rouge pour la consommation excessive

            # Tracé des barres empilées
            plot datafile every ::1 using (\$3 - \$2 > 0 ? \$3 - \$2 : 0):xtic(1) title "Énergie consommée en trop" linecolor rgb MaxColor, \
                 "" every ::1 using 2 title "Capacité" linecolor rgb MinColor

EOF

        echo "Graphique généré avec succès : $graphs/graphique_lvminmax${id_centrale:+_$id_centrale}.png"

        fin_temps=$(date +%s)
        duree=$((fin_temps - debut_temps))
        echo "Temps d'exécution du graphique : $duree secondes"

    fi

else
    echo "Erreur : GnuPlot n'est pas installé. Impossible de générer le graphique."
fi