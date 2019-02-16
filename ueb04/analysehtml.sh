#!/bin/dash 

######################################
# Script zur Analyse von HTML Datein #
# Von Andre Kloodt und Alex Löffler  #
######################################



########################################
# Die Funktion helpoutbut gibt unseren #
# Hilfetext auf stdout aus             #
########################################
helpoutput()
{
echo "Usage:
analysehtml.sh -h | analysehtml.sh --help

  prints this help and exits

analysehtml.sh INPUT OPTION

  provides a simple tool to analyse html-files. 

  INPUT is a valid html-file to analyse.

  OPTION is one of:

    -s, --structure : prints the structure as defined by the html-headlines

    -t, --statistic : prints the statistic concerning the documents links"
}


#######################################################
# Hier schauen wir ob -h (--help) übergeben wurde     #
# und sonst keine anderen Parameter. Falls mehrere    #
# Parameter angegeben werden erfolg eine Fehlerausgabe#               
#######################################################
if echo "$1"| grep -E -q '^(\-h|\-\-help)$' && echo "$#"| grep -E -q '1'; 
then 
	helpoutput
	exit 0

else if echo "$1"| grep -E -q '^(\-h|\-\-help)$' && [ "$#" != "1" ];
then 
	echo "Error: Falscher Aufruf der Help Option" >&2
	helpoutput >&2	
	exit 1	

     fi
fi



############################################################
# Hier Überprüfen wir, ob der Input (also die html)        #
# überhaupt existiert, wenn nicht mache Fehlerausgabe.     #
# @htmlvalue Hier speichern wir unsere HTML Datei          #
# nachdem wir alle Zeilenumbrüche und Kommentare           #
# entfernt haben, fügen wir hinter jedem Linktag einen     #
# Zeilenumbruch hinzu                                      # 
############################################################
if [ -r "$1" ]; then
	htmlvalue=$(cat $1 | tr -d "\n" | sed 's/-->/-->\n/g' | sed 's/<!--.*-->//g' | sed 's/\(<\/[aA]>\)/\1\n/g')   
	shift


        ##########################################################################
        # Hier Überprüfen wir, ob das Program mit der Option -s bzw --structure  #
        # aufgerufen wurde und ob keine Weiteren Parameter folgen                #              
        ##########################################################################
	if echo "$1"| grep -E -q '^(\-s|\-\-structure)$' && echo "$#"| grep -E -q '1'; 
	then 
            

            	##########################################################################
            	# Hier schauen wir ob es <hX> Tags gibt und wenn nicht, geben wir eine   #
            	# leerzeile aus                                                          #             
           	##########################################################################
        	if echo "$htmlvalue" | grep -cio "<[h][1-6]>" | grep -E -q '0' ; then	
			echo ""	
		
	    	else

                	############################################################################
                	# Hier Filtern wir unser @htmlvalue. Wir suchen nach den Überschriften und # 
                	# anschließend geben wir diese Sortiert nach ihrer Mächtigkeit aus         #             
               		############################################################################	 	
        		echo $htmlvalue | sed 's/<\/[hH][1-6]>/\n/g' |  grep -o '<[hH][1-6]>.*' | sed 's/<[hH][1]>//g' | sed 's/<[hH][2]>/  /g' |sed 's/<[hH][3]>/    /g' |sed 's/<[hH][4]>/      /g' |sed 's/<[hH][5]>/        /g' | sed 's/<[hH][6]>/          /g' 

	   	fi

        #######################################################################################
        # Hier Überprüfen wir, ob das Program mit der Option -t bzw --statistic               #
        # aufgerufen wurde und ob keine Weiteren Parameter folgen. Bei einem Falschen aufruf, # 
        # erfolgt eine Fehlerausgabe                                                          #              
        #######################################################################################
        else if echo "$1"| grep -E -q '^(\-t|\-\-statistic)$' && echo "$#"| grep -E -q '1'; 
	then 

                #############################################################################
                # Hier Filtern wir unser @htmlvalue. Wir zählen das Vorkommen verschiedener #
                # Links und geben die Anzahl dieser aus                                     #		
                # @links ist unsere Gesammtanzahl von links			            #
                # @htmlinks ist die Anzahl der links, die eine html endung haben            #
                # @archivlinks ist die Anzahl der links, die eine Archivendung haben        #             
                #############################################################################
		links=0
		htmllinks=0
		archivlinks=0
                
		links=$(echo "$htmlvalue" | grep -o -i "<[aA].*<\/[aA]>" | grep -cio "<a.*href\=.*<\/a>") 
  		htmllinks=$(echo "$htmlvalue" | grep -o -i "<[aA].*<\/[aA]>" | grep -c -i ".html") 
		archivlinks=$(echo "$htmlvalue" | grep -o -i "<[aA].*<\/[aA]>" | grep -c -i '\(\.tgz\|\.tar\.gz\|\.zip\|\.rar\)')


		echo "Document statistics"
		echo "All links: $links"
		echo "Links to html-pages: $htmllinks"
		echo "Links to archives: $archivlinks" 

	else 

		echo "Error: Falscher Aufruf der Parameter" >&2
		helpoutput >&2
		exit 3
	fi
fi




else 
	echo "Error: Keine HTML Datei mit dem Namen $1 gefunden" >&2
	helpoutput >&2
	exit 2
fi











