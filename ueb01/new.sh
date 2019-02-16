#! /bin/sh
# Script zum Sortieren von Textdateinamen 
# von  Andre Kloodt(inf102690) und Alexander Löffler (inf102691) 

# Hier wird der Ordner info erstellt
mkdir -p info

# Die Ausgabe von ls (mit -1 Sortiert) und gefiltert nach der .txt endung wird in mytextfiles.txt im Ordner info gestellt 
ls -1 *.txt > info/mytextfiles.txt 

