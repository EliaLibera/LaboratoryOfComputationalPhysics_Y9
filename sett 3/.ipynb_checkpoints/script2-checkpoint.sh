#!/bin/bash


# 2.a Pulizia metadati e rimozione virgole

# Rimuove le righe di metadati (es. quelle che iniziano con '#') e sostituisce le virgole con spazi
if [ -f "data.csv" ]; then
    grep -v "^#" data.csv | tr ',' ' ' > data.txt         #^ sta per inizia con
    echo "Creato 'data.txt' rimuovendo metadati e virgole."
else
    echo "Errore: File 'data.csv' non trovato."
    exit 1
fi


# 2.b Conteggio dei numeri pari

even_count=$(awk '{          
    for(i=1; i<=NF; i++) {                    
        if ($i % 2 == 0) count++;
    }
} END {print count+0}' data.txt)          #sommo 0 cosi se count resta vuoto visualizzo 0
#NF è l'ultima colonna della riga
echo "Numero totale di numeri pari: $even_count"


# 2.c Confronto con la soglia 100*sqrt(3)/2

# Si assume che ogni riga contenga le coordinate X, Y, Z nelle prime tre colonne ($1, $2, $3)
echo "coordinate (X,Y,Z)"
awk '{
    x = $1; y = $2; z = $3;
    val = sqrt(x*x + y*y + z*z);
    threshold = 100 * sqrt(3) / 2;
    if (val > threshold) {
        greater++;
    } else {
        smaller++;
    }
} END {
    print "Entrate con sqrt(X^2+Y^2+Z^2) >  100*sqrt(3)/2:", greater+0;
    print "Entrate con sqrt(X^2+Y^2+Z^2) <= 100*sqrt(3)/2:", smaller+0;
}' data.txt



# 2.d Generazione di n copie divise per i

# Richiede n come parametro d'ingresso (es. ./script2.sh 5)
if [ -z "$1" ]; then
    echo "Errore: Fornire il parametro 'n' come argomento dello script (es. ./script2.sh 5)."
    exit 1
fi

n=$1

for ((i=1; i<=n; i++))
{
    awk -v div="$i" '{
        for(j=1; j<=NF; j++) {
            printf "%s ", $j / div;         
        }
        print "";
    }' data.txt > "data_div_${i}.txt"
#con printf "%s", $j/div mando il valore j/div nella stringa s seguita da uno spazio. Alla fine del ciclo vado a capo con ""
}

echo "Generate con successo $n copie di data.txt divise da 1 a $n (file: data_div_1.txt ... data_div_${n}.txt)."
