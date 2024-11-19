#!/bin/bash

#Nom des arguments
fichier_csv="$1"
traitement="$2"

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