# Stanhl — Stan Syntax Highlighting in knitr

![A screenshot of stanhl syntax highlighting in a LaTeX document](https://raw.githubusercontent.com/vsbuffalo/stanhl/master/inst/extdata/example.png)


I needed a simple hack to highlight [Stan](http://mc-stan.org/) syntax in
[knitr](http://yihui.name/knitr/) files for [a course I'm
taking](http://xcelab.net/rm/statistical-rethinking/) — `stanhl` is that hack.
It's quick and dirty (e.g. this took me thirty minutes to write), but I thought
I'd share before polishing it.

## Requirements

You need [http://pygments.org](Pygments) installed. The following should work:

    $ pygmentize -V
    Pygments version 1.6, (c) 2006-2013 by Georg Brandl.

If you don't have Pygments installed, just install with the
[Python Package Index](https://pypi.python.org/pypi/Pygments):

    $ pip install Pygments

## Installation

Using the terrific [devtools](https://github.com/hadley/devtools) package, you
can install `stanhl` with:

    install_github('vsbuffalo/stanhl')

If you don't have `devtools` installed, use `install.packages('devtools')` first.

## Using `stanhl` in LaTeX (Rnw) files

There are two steps:

1. Include the following in your LaTeX header:

        \usepackage{fancyvrb}
        \usepackage{color}

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
        stanhl(m)

        @

Then, in another block call `stan()`, do other stuff, etc.

## Using `stanhl` in RMarkdown files

![A screenshot of stanhl syntax highlighting in an HTML document](https://raw.githubusercontent.com/vsbuffalo/stanhl/master/inst/extdata/example_html.png)

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
    stanhl(m)

    ```

## Highlighting Stan Models from File

You can also highlight a model directly from a `.stan` file:

    mesquite_file <- system.file("inst", "extdata", "mesquite_volume.stan",
                                 package="stanhl")
    stanhl_file(mesquite_file)

	# Then run your Stan model directly from file with something like:
	# fit <- stan(mesquite_file, data=mesquite_data)

## Styles

You can change Pygments [style](http://pygments.org/docs/styles/) used in syntax
highlighting with:

     > stanhl_styles() # get available style list (depends on Pygments plugins)
     [1] "monokai"  "manni"    "rrt"      "perldoc"  "borland"  "colorful"
     [7] "default"  "murphy"   "vs"       "trac"     "tango"    "fruity"
    [13] "autumn"   "bw"       "emacs"    "vim"      "pastie"   "friendly"
    [19] "native"
    > stanhl_opts$set(style="emacs")

See the vignette for these styles rendered.

## Todo

I interfaced Pygments with R to create syntax highlighting for Stan, but
afterwards thought it might be useful to have a more general R-Pygments
interface. This interface is now the
[pygmentr](https://github.com/vsbuffalo/pygmentr) package; I am debating
whether to merge these two together, or just keep stanhl separate. For now,
there are some Stan-specific features I want, e.g. including Stan models from
file, so this package is worth it.

