viewPipeChain <- function() {
  pc <- rstudioapi::getActiveDocumentContext()
  #if (!grepl("%>%", pc)) stop("Must highlight a pipe sequence")
  pc <- pc$contents
  pcTitles <- createViewTitles(pc)
  pcCalls <- createCalls(pc)
  createViews(pcCalls, pcTitles)
}

