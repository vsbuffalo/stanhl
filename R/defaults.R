# defaults.R -- internal options and code for handling pygments styles

#' List all styles (including plugins) available to Pygments
#'
#' @export
stanhl_styles <- function() {
  styles <- system2("python3",
                   args = c("-c",
                            "'from pygments.styles import get_all_styles;",
                            "print(list(get_all_styles()))'"),
                   stdout = TRUE)
  # Drop all non-words (except commas)
  styles <- gsub("[^a-z,]", "", styles)
  strsplit(styles, split = ",")[[1]]
}

#' Is the supplied syntax a vaild syntax?
#'
#' @importFrom glue glue
#' @param style a style to validate that it's available.
check_valid_style <- function(style) {
  if (!(style %in% stanhl_styles()))
    stop(glue::glue(style, " is not an available Pygments style."))
}

new_defaults <- function(opts = list()) {
  opts$validators <- list(style = check_valid_style)
  opts$get <- function(name) return(opts[[name]])

  # simple, but there's only two options!
  opts$set <- function(...) {
    dots <- list(...)
    if (length(dots) == 0) return()
    for (name in intersect(names(dots), names(opts$validators)))
      opts$validators[[name]](dots[[name]]) # validation for some options
    opts[names(dots)] <<- dots
  }
  opts$set(formatter = "latex")
  opts$set(style = "tango")

  return(opts)
}

#' Global options for stanhl
#'
#' @export
stanhl_opts <- new_defaults()
