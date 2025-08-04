#' Check for URL existence
#'
#' Taken from <https://stackoverflow.com/questions/52911812/check-if-url-exists-in-r>.
#'
#' @param url_in String of URL to test
#' @param t Time out
#' @examples
#' urls <- c(
#'   "http://www.amazon.com", "http://this.isafakelink.biz",
#'   "https://stackoverflow.com", "http://localhost:8080")
#' sapply(urls, valid_url)
#' @export
valid_url <- function(url_in, t = 2) {
  con <- url(url_in)
  check <- suppressWarnings(
    try(open.connection(con, open = "rt", timeout = t),
        silent = TRUE)[1])
  suppressWarnings(try(close.connection(con), silent = TRUE))
  ifelse(is.null(check), TRUE, FALSE)
}
