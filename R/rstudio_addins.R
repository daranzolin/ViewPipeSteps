process_selection <- function(cmd) {
  context <- rstudioapi::getActiveDocumentContext()
  selection <- context$selection[[1]]$text
  tryCatch({
    if (selection == "")
      stop("no text selected", call. = FALSE)
    call <- parse(text = selection)
    if(length(call) == 0)
      stop("selected text does not contain expression", call. = FALSE)
    call_list <- find_pipe_calls(call[[1]])
    process_pipe_call_list(call_list, cmd)
  },
  error = function(e) {
    rstudioapi::showDialog("viewPipeChain",
                           paste("Sorry: ", e), url="")
    return()
  })
}


#' @title Creates a View() output for each pipe step in current text selection
#'
#' @description
#'   Reads the currently selected text from the RStudio API and displays a data view
#'   in the source pane for each pipe step creating a unique object.
#'   Meant to be called as an RStudio addin.
#'
#' @export
viewPipeChain <- function() processPipeChain("View(ps%d, title = title)")


#' @title Prints each pipe step in current text selection
#'
#' @description
#'   Reads the currently selected text from the RStudio API and prints
#'   for each pipe step the resulting object if unique. Data frames are
#'   converted by as_tibble(). Meant to be called as an RStudio addin.
#'
#' @export
printPipeChain <- function() processPipeChain(print_command)
