# zzz.R

.onLoad <- function(libname, pkgname) {
  has_pygments()
  # special hack needed for RStudio's rmarkdown
  pygstyle <- get_pygments_header("html")
  if (is.null(stanhl_opts$get("rmarkdown_css"))) {
    # only set if not set.
    css_file <- tempfile(fileext=".css")
    writeLines(pygstyle, con=css_file)
    stanhl_opts$set(rmarkdown_css=css_file)
    options(rstudio.markdownToHTML =
            function(inputFile, outputFile) {
              require(markdown)
              markdownToHTML(inputFile, outputFile, stylesheet=css_file)
            })
  }
}
