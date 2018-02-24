createCalls <- function(x) {
  x <- purrr::map_chr(x, stringr::str_trim)
  calls <- list()
  for (i in 2:length(x)) {
    if (grepl("group_by", x[i])) next
    call <- paste(paste(x[1:i], collapse = " "), "View(")
    calls[[i]] <- call
  }
  invisible(purrr::discard(calls, is.null))
}

createViewTitles <- function(steps) {
  gbs <- sum(stringr::str_detect(steps, "group_by"))
  stepInds <- 2:(length(steps) - gbs)
  steps <- tail(purrr::map(strsplit(steps, "\\("), `[[`, 1), -1) %>%
    purrr::discard(~grepl("group_by", .)) %>%
    purrr::map_chr(stringr::str_trim)
  sprintf("%s. %s", (stepInds - 1), steps)
}

createViews <- function(calls, titles) {
  calls <- sprintf("%s title = '%s')", calls, titles)
  safeEval <- purrr::safely(eval)
  cList <-  purrr::map(calls, ~safeEval(parse(text = .)))
  for (i in seq_along(cList)) {
    if (!is.null(cList[[i]]$error)) {
      w <- sprintf("Pipe error at step %s: %s", titles[i], cList[[i]]$error)
      stop(w, call. = FALSE)
    }
  }
}
