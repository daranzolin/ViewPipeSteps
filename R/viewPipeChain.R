viewPipeChain <- function() {
  context <- rstudioapi::getActiveDocumentContext()
  pc <- stringr::str_remove(context$selection[[1]]$text, "\n")
  #if (!grepl("%>%", pc)) stop("Must highlight a pipe sequence", call. = FALSE)
  pc <- paste(strsplit(pc, "%>%")[[1]], "%>%")
  pcTitles <- createViewTitles(pc)
  pcCalls <- createCalls(pc)
  createViews(pcCalls, pcTitles)
}
