OBJECTS = Help.html

.PHONY: all clean distclean

all: $(OBJECTS)

%.html: %.md header.html footer.html SmartyPants.pl Markdown.pl
	cp header.html $@
	perl Markdown.pl $< | perl SmartyPants.pl >> $@
	cat footer.html >> $@

Markdown.pl:
	curl -O -L https://daringfireball.net/projects/downloads/Markdown_1.0.1.zip
	unzip Markdown_1.0.1.zip
	mv Markdown_1.0.1/Markdown.pl .
	rm -rf Markdown_1.0.1.zip Markdown_1.0.1

SmartyPants.pl:
	curl -O -L https://daringfireball.net/projects/downloads/SmartyPants_1.5.1.zip
	unzip SmartyPants_1.5.1.zip
	mv SmartyPants_1.5.1/SmartyPants.pl .
	rm -rf SmartyPants_1.5.1.zip SmartyPants_1.5.1

clean:
	rm -f $(OBJECTS)

distclean: clean
	rm -f Markdown.pl SmartyPants.pl
