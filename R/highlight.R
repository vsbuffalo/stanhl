#' Set up for highlighting Stan in LaTeX
#'
#' @export
stanhl_init = function() {
  has_pygments()
  make_header()
  add_stan_hook()
  knitr::raw_latex("\\input{highlight.tex}")
}


#' Check that pygments is installed.
has_pygments = function() {
  exit_status = system2("pygmentize", c("-V"), stdout = FALSE)
  if (exit_status != 0)
    stop("Pygments 'pygmentize' not found - have you installed Pygments?")
  invisible(exit_status == 0)
}


#' Set up commands for highlighting Stan in LaTeX.
make_header = function() {
  has_pygments()
  style = stanhl_opts$get("style")
  # Define Shaded

  cat(c("\\definecolor{shadecolor}{RGB}{248,248,248}",
        "\\ifcsmacro{Shaded}{}{\\newenvironment{Shaded}{\\begin{snugshade}}{\\end{snugshade}}}"),
      sep = "\n",
      file = "highlight.tex")
  # Add highlight commands
  cat(system2('pygmentize',
              args = c('-S', style, '-f', 'latex'),
              stdout = TRUE),
      sep = "\n",
      file = "highlight.tex",
      append = TRUE)
}

#' Add knitr hook to add highlighting to stan chunks.
add_stan_hook = function() {
  hook_output = knitr::knit_hooks$get("source")
  knitr::knit_hooks$set(source = function(x, options) {
    if (options$engine == 'stan') {
      # Apply syntax highlighting
      hlighted = stanhl(x)
      # Wrap in shaded enviornment
      paste('\\begin{Shaded}', hlighted, '\\end{Shaded}', sep = "\n")
    } else {
      hook_output(x, options)
    }
  })
}

#' Use pygements to highlight Stan model code.
stanhl = function(x) {
  has_pygments()
  paste(system2('pygmentize',
                args = c('-f', 'latex', '-l', 'stan'),
                input = x,
                stdout = TRUE),
        collapse = '\n')
}


#' Use Python Pygements to highlight Stan model code from a file.
#'
#' @param file a filename to a Stan model
#'
#' @export
stanhl_file = function(file) {

  if (!is.character(file) || length(file) > 1)
      stop("file must be a single string filename.")

  has_pygments()
  cat(system2('pygmentize',
              args = c('-f', 'latex', '-l', 'stan', file),
              stdout = TRUE),
      sep = "\n")
}
