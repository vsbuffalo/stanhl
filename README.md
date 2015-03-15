# Stanhl — Stan Syntax Highlighting in knitr

![A screenshot of stanhl syntax highlighting in a LaTeX document](https://raw.githubusercontent.com/vsbuffalo/stanhl/master/inst/extdata/example.png)


I needed a simple hack to highlight [Stan](http://mc-stan.org/) syntax in
[knitr](http://yihui.name/knitr/) files for a course I'm taking — `stanhl` is
that hack. It's quick and dirty (e.g. this took me thirty minutes to write), but
I thought I'd share before polishing it.

## Requirements

You need [http://pygments.org](Pygments) installed. The following should work:

    $ pygmentize -V
    Pygments version 1.6, (c) 2006-2013 by Georg Brandl.

## Using `stanhl` in LaTeX files

There are two steps:

1. Include the following in your LaTeX header:

        <<echo=FALSE,results='asis'>>=
        stan_latex()
        @ 

2. Write your Stan model, store it to a variable (e.g. to call with
`stan(model_code=x, ...`), and then use:

        <<echo=FALSE,results='asis'>>=
        library(stanhl)
        m <- "
		data {
		  // stan stuff
        }
		model {
		  // more stan stuff
		}
        "
        stanhl(m)
        
        @ 

Then, in another block call `stan()`, do other stuff. etc.

## Markdown support

I haven't test Markdown support (swamped for the next few weeks), but
`stan_html()` should work. If it doesn't, feel free to submit a pull request.








