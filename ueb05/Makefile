SHELL=/bin/dash

.PHONY: md help

SRC=$(wildcard *.sh)
OBJ=$(SRC:.sh=.md)
OBJ2=$(OBJ:.md=.html)

md:
	make $(OBJ)

%.md: %.sh
	cat $< | ./shelltomd > $@


html:
	make $(OBJ)
	make $(OBJ2)

%.html: %.md
	./Markdown.pl $< > $@

index:
	make $(OBJ)
	make $(OBJ2)
	make index.html

%.html: %.html
	$^ >> index.html
	




