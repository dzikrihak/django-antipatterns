markdowns = $(shell ls antipatterns/*.md patterns/*.md troubleshooting/*.md)
outhtml = $(markdowns:%.md=out_/%.html)
style = # https://bootswatch.com/4/slate/bootstrap.css  # 'https://raw.githubusercontent.com/sindresorhus/github-markdown-css/gh-pages/github-markdown.css' 

jss = $(shell ls site/*.js)
csss = $(shell ls site/*.css)
outjss = $(jss:site/%=out_/%)
outcsss = $(csss:site/%=out_/%)


all: out_ out_/CNAME $(outjss) $(outcsss) out_/antipatterns out_/patterns out_/troubleshooting $(outhtml) out_/index.html out_/favicon.ico out_/sitemap.xml

out_ :
	mkdir -p out_

out_/%.js: site/%.js
	yui-compressor --type js "$<" >"$@" || ln -f "$<" "$@"

out_/%.css: site/%.css
	yui-compressor --type css "$<" >"$@" || ln -f "$<" "$@"

index.md : toc.sh $(outhtml)
	bash toc.sh > "$@"

out_/sitemap.xml:
	git clone https://github.com/knyzorg/Sitemap-Generator-Crawler.git sitemap_
	php sitemap_/sitemap.php file="$@" site=https://www.django-antipatterns.com

out_/%.html: %.md Makefile templates/easy_template.html
	printf "<!DOCTYPE html><meta charset=\"utf-8\"><title>Redirecting to /$(@:out_/%=%)</title><meta http-equiv=\"refresh\" content=\"0; URL=/$(@:out_/%=%)\"><link rel=\"canonical\" href=\"/$(@:out_/%=%)\">" "$@" > $(subst -,_,$@)
	pandoc -s -f markdown -t html --template=templates/easy_template.html -c "${style}" --highlight-style haddock -o "$@" "$<"

out_/%.ico : media/%.ico
	ln "$<" "$@"

out_/CNAME: site/CNAME
	ln -f site/CNAME out_/CNAME

out_/%:
	mkdir -p "$@"

hunspell:antipatterns/*.md patterns/*.md troubleshooting/*.md
	hunspell -H "$<"
