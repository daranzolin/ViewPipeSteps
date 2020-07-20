print_command <- c(
  "message(title);",
  "obj <- ps%d;",
  "if (is.data.frame(obj)) obj <- tibble::as_tibble(obj);",
  "print(obj)"
)


find_pipe_calls <- function(x) {
  if (!is.call(x)) stop("expression is not a call", call. = FALSE)
  if (identical(x[[1]], quote(`do.call`)))
      stop("calls using do.call() are not supported", call. = FALSE)
  if (!identical(x[[1]], quote(`<-`)) &&
      !identical(x[[1]], quote(`%>%`)) &&
      !identical(x[[1]], quote(`%P>%`)) &&
      !identical(x[[1]], quote(`assign`)))
    stop("call is neither an assignment nor a pipe", call. = FALSE)
  pl <- list()
  done <- FALSE
  repeat{
    if (identical(x[[1]], quote(`<-`)) ||
        identical(x[[1]], quote(`assign`))) {
      x <- x[[3]]
      if (!is.call(x))
        stop("RHS of assignment does not contain call", call. = FALSE)
      if (!identical(x[[1]], quote(`%>%`)))
        stop("RHS of assignment does not contain pipe", call. = FALSE)
    } else
    if (identical(x[[1]], quote(`%>%`)) || identical(x[[1]], quote(`%P>%`))) {
      pl <- c(pl, x[[3]])
      if (is.symbol(x[[2]]) || !(identical(x[[2]][[1]], quote(`%>%`)) ||
                                 identical(x[[2]][[1]], quote(`%P>%`)))) {
        pl <- c(pl, x[[2]])
        done <- TRUE
      } else x <- x[[2]]
    }
    if (done) break
  }
  rev(pl)
}


process_pipe_call_list <- function(call_list, cmd, all = FALSE) {
  call_list_str <- as.character(call_list)
  for(i in 1:length(call_list)) {
    title <- sprintf("%d. %s", i, call_list_str[i])
    if (i == 1) ps1 <- eval(call_list[[i]]) else {
      call <- parse(text = paste(sprintf("ps%d %%>%%", i - 1),
                                 paste0(deparse(call_list[[i]]),
                                        collapse = " ")))
      assign(sprintf("ps%d", i), eval(call))
    }
    assign(
      sprintf("obj%d", i),
      if (!all && is.data.frame(get(sprintf("ps%d", i)))) {
        as.data.frame(get(sprintf("ps%d", i)))
      } else {
        get(sprintf("ps%d", i))
      }
    )
    if (i == 1 || !identical(get(sprintf("obj%d", i)),
                             get(sprintf("obj%d", i- 1))))
      eval(parse(text = sprintf(cmd, i)))
  }
}
