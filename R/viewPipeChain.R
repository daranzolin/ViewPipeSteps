viewPipeChain <- function() {
  context <- rstudioapi::getActiveDocumentContext()
  context <- context$selection[[1]]$text

  if (grepl("\n", context)) {
    calls <- stringr::str_split(context, "\n")[[1]] %>%
      purrr::map_chr(~gsub("\\#.*","",.)) %>%
      purrr::map_chr(stringr::str_trim) %>%
      purrr::discard(~.=="")
  } else {
    calls <- paste(stringr::str_split(context, "%>%")[[1]], "%>%") %>%
      stringr::str_trim()
  }

  if (grepl("<-$", calls[1])) calls <- calls[-1]

  pcTitles <- createViewTitles(calls)
  pcCalls <- createCalls(calls)
  createViews(pcCalls, pcTitles)
}
