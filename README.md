# Stanhl - Stan syntax highlighting in RMarkdown

<!-- badges: start -->
  [![Travis build status](https://travis-ci.com/jr-packages/stanhl.svg?branch=master)](https://travis-ci.com/jr-packages/stanhl)

![A screenshot of stanhl syntax highlighting in a LaTeX
document](https://raw.githubusercontent.com/jr-packages/stanhl/master/inst/extdata/example.png)

Add syntax highlighting to stan code chunks in RMarkdown for `pdf` output. 

---
## Requirements

1. [Pygments](https://pygments.org/download/)
2. [Pandoc 2.x](https://github.com/jgm/pandoc/releases/tag/2.11.0.2) (currently
   shipped with the RStudio preview version)

---
## Installing

You can install this package as:
```r
install.packages('devtools')
install_github('jr-packages/stanhl')
```

---
## Usage

This package is intended to provide syntax highlighting for RMarkdown documents
which are targeting a _pdf_ output. That is, this package does _not_ support
html output in its current format.

This
[MWE](https://github.com/jr-packages/stanhl/blob/master/inst/extdata/mwe.Rmd)
represents a full working example. But in summary:

1. To knit your document to pdf there are a few LaTeX packages which must be
   included (either in `header-includes` or `extra-dependencies`). These are
   the `fancyvrb`, `framed` and `etoolbox` packages.

2. Execute `stanhl::stanhl_init()` in an R chunk at the top of your file (or
   *at least* before any stan code).

3. Add stan code which you wish to highlight to ```stan``` chunks.
---
