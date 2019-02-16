#! /bin/bash
# Script Aufgabe 2
# Von Andre Kloodt und Alexander Löffler 




# Sort sortiert Nummerisch die Spalten 2 und 3 unter dem Trennzeichen ; (-t)
#cut schneidet (mit Trennzeichen ;) alle error Zeilen raus


#tee Dubliziert die Ausgabe und danach wird stdout mit tail und cut gekürzt  

sort -k2 -k3  -n -t";" -r | cut -d";" -s -f 1,2,3  | tee "$1" | tail -n 1 | cut -d";" -f 1

 
