viewPipeChain <- function() {
  context <- rstudioapi::getActiveDocumentContext()
  pc <- context$selection[[1]]$text
  #if (!grepl("%>%", pc)) stop("Must highlight a pipe sequence", call. = FALSE)
  pc <- strsplit(pc, "\n")[[1]]
  pcTitles <- createViewTitles(pc)
  pcCalls <- createCalls(pc)
  createViews(pcCalls, pcTitles)
}

