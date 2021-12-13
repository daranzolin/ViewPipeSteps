# See: http://adv-r.had.co.nz/Expressions.html

purge_pnp_from_lhs <- function(x) {
  if (is.atomic(x) || is.name(x)) {
    x
  } else if (is.call(x)) {
    if (identical(x[[1]], quote(`%P>%`))) {
      x[[1]] <- quote(`%>%`)
      purge_pnp_from_lhs(x)
    } else x <- as.call(lapply(x, purge_pnp_from_lhs))
  } else if (is.pairlist(x)) {
    x <- as.call(lapply(x, purge_pnp_from_lhs))
  } else {
    stop("Don't know how to handle type ", typeof(x))
  }
}

print_and_pipe <- function() {
  function(lhs, rhs) {
    parent <- parent.frame()
    my_call <- match.call()
    new_lhs <- purge_pnp_from_lhs(my_call[[2]])
    object <- eval(new_lhs, parent, parent)
    message(sprintf("Printing %s",
                    paste(trimws(deparse(new_lhs)), collapse = " ")))
    if (is.data.frame(object)) object <- tibble::as_tibble(object)
    print(object)
    my_call[[1]] <- quote(`%>%`)
    eval(my_call, parent, parent)
  }
}

#' @title \code{\%P>\%} Prints and pipes
#'
#' @description
#'   This pipe variant prints the object received from the left hand side prior
#'   to piping it to the right hand side.
#'
#' @param lhs
#'   The left hand side of the pipe.
#' @param rhs
#'   The right hand side of the pipe.
#'
#' @return called for side effects
#'
#' @note
#'   This code is experimental. Use at your own risk.
#'
#' @examples
#'   if (!require(dplyr)) stop("Examples need dplyr to run")
#'   mtcars %>%
#'     filter(am == 1) %P>%
#'     select(qsec)
#'
#' @rdname print_and_pipe
#' @export
`%P>%` <- print_and_pipe()
