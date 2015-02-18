Src=phaseDelay
Name=15phaseDelay
Bib=refs.bib 

all : dirs tex bib  tex tex embedfonts done


publish : dirs all
	cp $(HOME)/tmp/$(Src).pdf pdf/$(Name).pdf
	chmod a+r pdf/$(Name).pdf
	scp -p pdf/$(Name).pdf stuff@ttoy.net:menzies.us/pdf

commit:; - git status; git commit -a; git push origin master
typo:  ; - git status; git commit -am "typo"; git push origin master
update:; - git pull origin master
status:; - git status
gitting:
	git config --global credential.helper cache
	git config credential.helper 'cache --timeout=3600'


view :
	evince $(HOME)/tmp/$(Src).pdf &

one : dirs tex done 

ready :
	mkdir -p $(HOME)/tmp

done :
	@printf "\n\n\n==============================================\n"
	@printf       "see output in $(HOME)/tmp/$(Src).pdf\n"
	@printf       "==============================================\n\n\n"
	@printf "\n\nWarnings (may be none):\n\n"
	grep arning $(HOME)/tmp/${Src}.log

dirs : 
	- [ ! -d $(HOME)/tmp ] && mkdir $(HOME)/tmp
	- [ ! -d pdf ] && mkdir pdf

tex : ready
	- pdflatex  -output-directory=$(HOME)/tmp $(Src)

embedfonts:
	@ gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite \
          -sOutputFile=$(HOME)/tmp/$(Src)-embedded.pdf $(HOME)/tmp/$(Src).pdf
	@ mv              $(HOME)/tmp/$(Src)-embedded.pdf $(HOME)/tmp/$(Src).pdf

bib : 
	- cp $(Bib) $(HOME)/tmp; cd $(HOME)/tmp; bibtex $(Src)
