has_pygments <- function() {
  exit_status <- system("pygmentize -V", ignore.stdout=TRUE, ignore.stderr=TRUE)
  if (exit_status != 0)
    stop("Pygments 'pygmentize' not found - have you installed Pygments?")
  invisible(exit_status == 0)
}

#' Build and run command with system(..., intern=TRUE)
pipe_in <- function(cmd, input=NULL) {
  out <- system(cmd, input=input, intern=TRUE)
  paste(out, sep="\n", collapse="\n")
}

#' Setup Stan syntax highlighting for LaTeX files
#'
#' @export
stanhl_latex <- function() {
  has_pygments()
  stanhl_opts$set(formatter="latex")
  cat(get_header("latex"))
}

#' Setup Stan syntax highlighting for HTML files
#'
#' @export
stanhl_html <- function() {
  has_pygments()
  stanhl_opts$set(formatter="html")
  style_tmp = '
<style type="text/css">
/* automatically generated with Pygments */
%s
</style>'
  cat(sprintf(style_tmp, get_header("html")))
}


#' Create Stan highlight header for LaTeX or HTML
#'
get_header <- function(formatter=c("latex", "html")) {
  has_pygments()
  formatter <- match.arg(formatter)
  style <- stanhl_opts$get("style")
  pipe_in(cmd=sprintf('pygmentize -S "%s" -f "%s"', style, formatter))
}


#' Highlight Stan model code
#'
#' Uses Python Pygements to highly Stan model code.
#'
#' @param x character model specification.
#'
#' @export
stanhl <- function(x) {
  has_pygments()
  formatter <- stanhl_opts$get("formatter")
  cat(pipe_in(cmd=sprintf('pygmentize -f "%s" -l stan', formatter),
              input=x))
}

