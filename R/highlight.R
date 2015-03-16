has_pygments <- function() {
  exit_status <- system("pygmentize -V", ignore.stdout=TRUE, ignore.stderr=TRUE)
  if (exit_status != 0)
    stop("Pygments 'pygmentize' not found - have you installed Pygments?")
  invisible(exit_status == 0)
}

#' Grab the current knitr formatter
#'
get_knitr_outformat <- function() {
  format <- opts_knit$get("out.format")
  if (!(format %in% c("latex", "html", "markdown"))) {
    # TODO: other formats should be supported
    msg <- "knitr's out.format ('%s') must be either 'html' nor 'latex'"
    stop(sprintf(msg, format))
  }
  if (format == "markdown") format <- "html"
  format
}

#' Build and run command with system(..., intern=TRUE)
#'
#' @param cmd command to execute with \code{system(....)}.
#' @param input string input to be passed through standard input to \code{cmd}.
pipe_in <- function(cmd, input=NULL) {
  out <- system(cmd, input=input, intern=TRUE)
  paste(out, sep="\n", collapse="\n")
}


#' Create Stan highlight header for LaTeX or HTML
#'
#' @param formatter Pygments formatter to use; either "latex" or "html".
get_pygments_header <- function(formatter=c("latex", "html", "markdown")) {
  has_pygments()
  formatter <- match.arg(formatter)
  style <- stanhl_opts$get("style")
  pipe_in(cmd=sprintf('pygmentize -S "%s" -f "%s"', style, formatter))
}


#' Set the opts_knit 'header' to the default knitr header combined with the
#' Pygments header
#'
#' \code{set_knitr_header()} will automatically get the knitr output format and
#' use this to create a header.
set_knitr_header <- function(format) {
  headers <- list(html=knitr:::.header.hi.html, latex=knitr:::.header.hi.tex,
                  markdown=knitr:::.header.hi.html)
  # combine the default header from knitr with the necessary pygments stylings
  #if (!nzchar(opts_knit$get('header')['highlight']))
  #  stop("Option 'header' already set in opts_knit.")  # avoid clobbering
  pygstyle <- get_pygments_header(format)
  h <- paste(headers[[format]], pygstyle, sep="\n")
  set_header(highlight = h)
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
  format <- get_knitr_outformat()
  set_knitr_header(format)
  cat(pipe_in(cmd=sprintf('pygmentize -f "%s" -l stan', format),
              input=x))
}

#' Highlight Stan model code from file
#'
#' Uses Python Pygements to highly Stan model code from a file.
#'
#' @param file a filename to a Stan model
#'
#' @export
stanhl_file <- function(file) {
  if (!is.character(file) || length(file) > 1)
      stop("file must be a single string filename.")
  has_pygments()
  format <- get_knitr_outformat()
  set_knitr_header(format)
  cat(pipe_in(cmd=sprintf('pygmentize -f "%s" -l stan "%s"', format, file)))
}







