#!/bin/bash

#1.a
STUDENTS_DIR="Students"       #aggiungere prima Home/ se si vuole salvare nella home
CSV_URL="https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv?dl=1"   #aggiungo ?dl=1 per riferirmi alla tabella
CSV_FILENAME="LCP_22-23_students.csv"

mkdir -p "$STUDENTS_DIR"
cd "$STUDENTS_DIR"

if [ -f "$CSV_FILENAME" ]; then
    echo "Il file $CSV_FILENAME è già presente."
else
    curl -fL -o "$CSV_FILENAME" "$CSV_URL"       #al posto di wget, con -L segue i redirect e con f annulla se c'è errore
fi

#1.b
awk -F',' '$4=="PoD"' "$CSV_FILENAME" > students_pod.csv
awk -F',' '$4=="Physics"' "$CSV_FILENAME" > students_physics.csv

# 1.c Conteggio studenti per iniziale del cognome

echo "Conteggio studenti per iniziale del cognome:"
for letter in {A..Z}; do
    count=$(tail -n +2 "$CSV_FILENAME" | awk -F',' -v l="$letter" 'toupper(substr($1,1,1)) == l' | wc -l)
    if [ "$count" -gt 0 ]; then
        echo "Lettera $letter: $count"
    fi
done


# 1.d Lettera con il maggior numero di conteggi
echo "Lettera con il maggior numero di conteggi"
tail -n +2 "$CSV_FILENAME" | awk -F',' '{print toupper(substr($1,1,1))}' | sort | uniq -c | sort -nr | head -n 1 #tiene la prima riga

# 1.e Raggruppamento Modulo 18

sed -n '1p' "$CSV_FILENAME" > header.csv

# Smistamento delle righe partendo dalla riga 3 in poi
tail -n +2 "$CSV_FILENAME" | awk -F',' '{ print > ("group_" ((NR-1)%18)+1 ".csv") }'

# Aggiunge l'intestazione a ciascun file di gruppo generato
for f in group_*.csv; do
    cat header.csv "$f" > temp && mv temp "$f"
done
rm header.csv

echo "Studenti raggruppati modulo 18 nei file 'group_1.csv' ... 'group_18.csv'."
