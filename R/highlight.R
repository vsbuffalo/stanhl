
has_pygments <- function() {
  exit_status <- system("pygmentize -V", ignore.stdout=TRUE, ignore.stderr=TRUE)
  if (exit_status != 0)
    stop("Pygments 'pygmentize' not found - have you installed Pygments?")
  invisible(exit_status == 0)
}

#' Build and run command with system(..., intern=TRUE)
#' (functions like sprintf())
pipe_in <- function(cmd, input=NULL) {
  out <- system(cmd, input=input, intern=TRUE)
  paste(out, sep="\n", collapse="\n")
}

#' Setup Stan syntax highlighting for LaTeX files
#'
#' @export
stan_latex <- function() {
  has_pygments()
  use_stanhl("latex")
}

#' Setup Stan syntax highlighting for HTML files
#'
#' @export
stan_html <- function() {
  has_pygments()
  use_stanhl("html")
}


#' Initiate Stan highlight header for LaTeX
#'
use_stanhl <- function(formatter=c("latex", "html")) {
  has_pygments()
  formatter <- match.arg(formatter)
  cat(pipe_in(cmd=sprintf('pygmentize -S default -f "%s"', formatter)))
}


#' Highlight Stan model code
#'
#' Uses Python Pygements to highly Stan model code.
#'
#' @param x character model specification
#' @param formatter either "latex" or "html"; the format of output
#'
#' @export
stanhl <- function(x, formatter=c("latex", "html")) {
  has_pygments()
  formatter <- match.arg(formatter)
  cat(pipe_in(cmd=sprintf('pygmentize -f "%s" -l stan', formatter), input=x))
}


