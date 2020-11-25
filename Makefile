markdowns = $(shell ls antipatterns/*.md patterns/*.md)
outhtml = $(markdowns:%.md=out_/%.html)
style = # https://bootswatch.com/4/slate/bootstrap.css  # 'https://raw.githubusercontent.com/sindresorhus/github-markdown-css/gh-pages/github-markdown.css' 

all: out_ out_/antipatterns out_/patterns $(outhtml) out_/index.html out_/favicon.ico
out_ :
	mkdir -p out_
index.md : toc.sh $(outhtml)
	bash toc.sh > "$@"
out_/%.html: %.md Makefile templates/easy_template.html
	pandoc -s -t html --template=templates/easy_template.html -c "${style}" --highlight-style haddock -o "$@" "$<"

out_/%.ico : media/%.ico
	ln "$<" "$@"

out_/%:
	mkdir -p "$@"
