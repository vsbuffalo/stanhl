# defaults.R -- internal options and code for handling pygments styles

parse_PyList <- function(x) {
  tmp <- strsplit(gsub("\\[(.*)\\]", "\\1", x), ", ")[[1]]
  gsub("'", "", tmp, fixed=TRUE)
}

#' List all styles (including plugins) available to Pygments
#' 
#' @export
stanhl_styles <- function() {
  cmd <- paste0("python -c 'from pygments.styles import get_all_styles;",
                "print list(get_all_styles())'")
  # greedy is ok here; formatted as Python list
  parse_PyList(pipe_in(cmd))
}

#' Is the supplied syntax a vaild syntax?
#'
#' @param style a style to validate that it's available.
check_valid_style <- function(style) {
  if (!(style %in% stanhl_styles()))
    stop(sprintf("'%s' is not an available Pygments style.", style)) 
}

new_defaults <- function(opts=list()) {
  opts$validators <- list(style=stanhl:::check_valid_style)
  opts$get <- function(name) return(opts[[name]])
  # simple, but there's only two options!
  opts$set <- function(...) {
    dots <- list(...)
    if (length(dots) == 0) return()
    for (name in intersect(names(dots), names(opts$validators)))
      opts$validators[[name]](dots[[name]]) # validation for some options
    opts[names(dots)] <<- dots
  }
  opts$set(formatter="latex")
  opts$set(style="default")
  return(opts)
}

#' Global options for stanhl
#'
#' @export
stanhl_opts <- new_defaults()





