#' @title Prints the return objects of all pipe steps to console
#'
#' @description
#'   Added as last command to a pipe, prints for each pipe step the resulting
#'   object to the console if unique. Data frames are converted by as_tibble().
#'
#' @param .data
#'   The data, normally handed over from the prior pipe step.
#'
#' @param cmd
#'   The command to be evaluated for each object. Takes ps%d as placeholder for
#'   object of step  %d and title for the title of the view. See below for an
#'   example.
#'
#' @param all
#'   Whether you want to print objects even if they are identical. Helpful
#'   when you want to display changes in grouping.
#'
#' @return The unchanged data
#'
#' @examples
#' \dontrun{
#' if (!require(dplyr)) stop("Examples need dplyr to run")
#' mtcars %>%
#'   filter(am == 1) %>%
#'   select(qsec) %>%
#'   print_pipe_steps() -> result
#'
#' my_print_cmd <- c(
#'   "message(title);",
#'   "skimr::skim_tee(.data = ps%d)"
#' )
#'
#' mtcars %>%
#'   select(am, hp, mpg) %>%
#'   group_by(am) %>%
#'   print_pipe_steps(my_print_cmd, all = TRUE) %>%
#'   summarize(
#'     nobs = n(),
#'     mean_hp = mean(hp),
#'     mean_mpg = mean(mpg)
#'   )
#' }
#' @export
print_pipe_steps <- function(.data, cmd = print_command, all = FALSE) {
  # Find pipe call in call stack
  i <- 1
  while(!any(grep("print_pipe_steps\\(.*\\)", as.character(sys.call(i)))) &&
        i < sys.nframe()) {
    i <- i+1
  }
  call <- sys.call(i)
  call_list <- find_pipe_calls(call)

  # remove print_pipe_chain() and all following steps from call_list
  ppc_pos <- which(grepl("print_pipe_steps\\(.*\\)", as.character(call_list)))
  call_list <- call_list[1:(ppc_pos - 1)]

  process_pipe_call_list(call_list, cmd, all)

  .data
}
