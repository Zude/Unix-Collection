#!/bin/bash 

#Script zur Berechnung von Mathematischen Ausdrücken
#Von Andre Kloodt und Alexander Löffler

#Variable die testen wird, ob unsere Erste if abfrgae Zahl Zahl Operator bereits einmal gemacht wurde
wurdschon=false

# Bewirkt, dass das Programm bei einem exit code != 0 sofort aufhört
set -e



###########################################################################################################
# Die Funktion berechnet anahnd der Parameter die Gewünschten Ausdrücke, die Ausgabe wird so Formatiert,  
# dass wir eine "Normale" Ausgabe haben und eine Spezielle, für den Fall, dass das Programm mit 
# -i aufgerufen wird. Außerdem wird getestet ob eine 0 als Divisor übergeben wird (Fehler) 
# und ob der Zweite Parameter negativ ist (Um die Ausgabe zu Klammern für -i)
#
# $1 Ist Hier die erste Zahl in der Berechnung
# $2 Ist stets die zweite Zahl für die Berechnung
# $3 Ist der Operator, der entscheidet welcher Fall im Case angewendet wird
# $4 Ist unser Visueller String (der aktuelle Klammerausdruck für die Ausgabe mit -i)
########################################################################################################### 
function rechner ()
{

local a
local b
local c

if [ "$2" == "0" ] && ([ "$3" == "MOD" ] || [ "$3" == "DIV" ]); then
	echo "Error: Keine Divisionen durch 0" >&2
	hilfetext
	exit 1
fi


if [ "$4" == "$1" ] && [ "$1" -lt "0" ]; then
	 c="($4)"
else 
	 c="$4"
fi

case "$3" in
	ADD) a=$(($1 + $2)); if [ "$2" -lt "0" ]; then b="($c+($2))"; else b="($c+$2)"; fi; echo "$a;$b";;
        SUB) a=$(($1 - $2)); if [ "$2" -lt "0" ]; then b="($c-($2))"; else b="($c-$2)"; fi; echo "$a;$b";;
        MUL) a=$(($1 * $2)); if [ "$2" -lt "0" ]; then b="($c*($2))"; else b="($c*$2)"; fi; echo "$a;$b";;
        DIV) a=$(($1 / $2)); if [ "$2" -lt "0" ]; then b="($c/($2))"; else b="($c/$2)"; fi; echo "$a;$b";;
        MOD) a=$(($1 % $2)); if [ "$2" -lt "0" ]; then b="($c%($2))"; else b="($c%$2)"; fi; echo "$a;$b";;
esac
}

#################################################
#Die Funktion gibt den Hilfetext auf Stderr aus
#################################################
function hilfetext ()
{
echo "Usage:
pfcalc.sh -h | pfcalc.sh --help

  prints this help and exits

pfcalc.sh [-i | --visualize] NUM1 NUM2 OP [NUM OP] ...

  provides a simple calculator using a postfix notation. A call consists of
  an optional parameter, which states whether a visualization is wanted,
  two numbers and an operation optionally followed by an arbitrary number
  of number-operation pairs.

  NUM1, NUM2 and NUM have to be integer numbers.

  NUM is treated in the same way as NUM2 whereas NUM1 in this case is the
  result of the previous operation.

  OP is one of:

    ADD - adds NUM1 and NUM2

    SUB - subtracts NUM2 from NUM1

    MUL - multiplies NUM1 and NUM2

    DIV - divides NUM1 by NUM2 and returns the integer result

    MOD - divides NUM1 by NUM2 and returns the integer remainder

  When the visualization is active the program additionally prints the
  corresponding mathematical expression before printing the result." >&2
}


#Hier wird gecheckt, ob überhaupt Parameter übergeben wurden, ansonsten Fehler
if [ "$#" == "0" ]; then
	echo "Error: Es müssen Parameter übergeben werden" >&2
	hilfetext
	exit 2
fi

#Hier testen wir ob der Erste Parameter -i ist und danach noch ausreichend Parameter folgen für einen gültigen aufruf. 
#itester wird auf true gesetzt, damit wir bei der Ausgabe wissen, wie wir ausgeben sollen
if [ "$1" == "-i" ] && [ "$#" -gt "3" ]; then
	itester=true
	shift
else if [ "$1" == "-i" ] && [ "$#" -lt "4" ]; then
	echo "Error: -i braucht weitere Parameter" >&2
	hilfetext
	exit 3
     fi
fi

#Hier wird geschaut, ob wir einen gültigen Aufruf der Usage haben. Die funktion Hilfetext wird von stderr auf stdout umgeleitet bei einem gültigen Aufruf
if ([ "$1" == "-h" ] || [ "$1" == "--help" ]) && [ "$#" == "1" ]; then
	hilfetext 2>&1
	shift
	exit 0
else if ([ "$1" == "-h" ] || [ "$1" == "--help" ]) && [ "$#" -gt "1" ]; then 
	echo "Error: Hinter einem Help dürfen keine weiteren Parameter kommen" >&2
	hilfetext
	exit 4
     fi
fi



#Die While Schleife Arbeitet die Parameter ab, die übergeben wurden und shiftet nach jedem Durchlauf 
while [ $# -gt 0 ]; do

#Diese If-Abfrage testet, ob die Parameter dem Format Zahl Zahl Operator entsprechen und sie testestet ob solch ein Aufruf zum ersten mal passiert. 
#Bei Erfolg werden unsere Parameter an die Funktion rechner übergeben. Anschließend wird die Ausgabe auf 2 Variablen aufgeteilt (Für die normale Ausgabe und die mit -i). 
#Da solch ein Aufruf nur einmal im Programm passieren darf, wird die Variable wurschon auf true gesete

if ([ "$1" -eq "$1" ] && [ "$2" -eq "$2" ] && ([ "$3" == "ADD" ] || [ "$3" == "SUB" ] || [ "$3" == "MUL" ] || [ "$3" == "DIV" ] || [ "$3" == "MOD" ] && [ "$wurdschon" == "false" ])) 2>/dev/null; then
	resu=$(rechner $1 $2 $3 $1)
	normalresu=$(echo $resu | cut -f1 -d";")
	visuresu=$(echo $resu | cut -f2 -d";")
	wurdschon=true
	shift
	shift

#Hier testen wir, ob das Format der Parameter Zahl Operator ist und ob wurdschon true ist (was vorraussetzung für diesen Aufruf ist). 
#Bei Erfolg werden die Paramet der Funktion rechner übergeben und die Ausgabe anschließießend Aufgeteilt
else if ([ "$1" -eq "$1" ] && ([ "$2" == "ADD" ] || [ "$2" == "SUB" ] || [ "$2" == "MUL" ] || [ "$2" == "DIV" ] || [ "$2" == "MOD" ] && [ "$wurdschon" == "true" ])) 2>/dev/null; then
	resu=$(rechner $normalresu $1 $2 $visuresu) 
	normalresu=$(echo $resu | cut -f1 -d";")
	visuresu=$(echo $resu | cut -f2 -d";")
	shift
     else 
	echo "Error: Du hast falsche Parameter eingegeben" >&2
	hilfetext
	exit 5
	shift
     fi
fi 

shift
done


# Hier wird Abhängig von itester die gewünschte Ausgabe formatiert 
if [ "$itester" == "true" ]; then

	echo "$visuresu"
fi

	echo "$normalresu"

