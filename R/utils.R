#' Build and run command with system(..., intern=TRUE)
#'
#' @param cmd command to execute with \code{system(....)}.
#' @param input string input to be passed through standard input to \code{cmd}.
pipe_in <- function(cmd, input=NULL) {
  out <- system(cmd, input=input, intern=TRUE)
  paste(out, sep="\n", collapse="\n")
}

