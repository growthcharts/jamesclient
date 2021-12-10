is.url <- function(x) {
  if (!length(x)) return(FALSE)
  grepl("^https?://", x, useBytes = TRUE)
}
