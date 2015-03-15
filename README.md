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

## Installation

Using the terrific [devtools](https://github.com/hadley/devtools) package, you
can install `stanhl` with:

    install_github('vsbuffalo/stanhl')

If you don't have `devtools` installed, use `install.packages('devtools')` first.

## Using `stanhl` in LaTeX (Rnw) files

There are two steps:

1. Include the following in your LaTeX header:

        <<echo=FALSE,results='asis'>>=
        library(stanhl)
        stanhl_latex()
        @ 

2. Write your Stan model, store it to a variable (e.g. to call with
`stan(model_code=x, ...`), and then use:

        <<echo=FALSE,results='asis'>>=
        m <- "
		data {
		  // stan stuff
        }
		model {
		  // more stan stuff
		}
        "
        cat(stanhl(m))
        
        @ 

Then, in another block call `stan()`, do other stuff. etc.

## Using `stanhl` in RMarkdown files

I haven't extensively tested Markdown support (swamped for the next few weeks),
but `stanhl_html()` should work as a replacement for `stanhl_latex()`. If it
doesn't, feel free to submit a pull request. Below is the basic idea.

The header:
     
    ```{r,echo=FALSE,results='asis'}
    library(stanhl)
    stanhl_html()
    ```

The meat and potatoes (or tofu and eggplant):

    ```{r,echo=FALSE,results='asis'}
    m <- "
    data {
      int<lower=0> N;
      vector[N] weight;
      vector[N] diam1;
      vector[N] diam2;
      vector[N] canopy_height;
    }
    transformed data {
      vector[N] log_weight;
      vector[N] log_canopy_volume;
      log_weight        <- log(weight);
      log_canopy_volume <- log(diam1 .* diam2 .* canopy_height);
    }
    parameters {
      vector[2] beta;
      real<lower=0> sigma;
    }
    model {
      log_weight ~ normal(beta[1] + beta[2] * log_canopy_volume, sigma);
    }
    "
    cat(stanhl(m))

    ```








