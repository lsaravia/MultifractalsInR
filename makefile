SRC = $(wildcard Curs*.md)

HTML=$(SRC:.md=.html)

all: $(HTML)



%.html: %.md 
#	pandoc -s -S -i -t slidy  --mathjax="/home/leonardo/MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML" --slide-level 2 $^ -o $@ 
	pandoc -s -S -i -t slidy  --mathjax --slide-level 2 $^ -o $@ 
#	pandoc -s -S -i -t slidy  -V slidy-url=Slidy2 --mathjax="/home/leonardo/MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML" --slide-level 2 $^ -o $@ 


	#chromium-browser Curso1_slidy.html

%.pdf: %.md
	pandoc -s -S --slide-level 2 -t beamer $^ -o $@
#	evince $@


#all: Curso.html CursoR1.html Curso1.html Curso2.html CursoR2.html Curso3.html CursoR3.html Curso4.html
#all: Curso.pdf CursoR1.pdf Curso1.pdf Curso2.pdf CursoR2.pdf Curso3.pdf CursoR3.pdf Curso4.pdf

