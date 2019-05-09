#' Extract useful parts from OpenCPU response
#'
#' \code{extract_location()} extracts the location
#' @param resp An object of class \code{\link[httr:response]{response}}
#' @return A url
#' @rdname extract
#' @export
extract_location <- function(resp)
  headers(resp)$location

#' \code{extract_session()} extracts the session ID
#' @rdname extract
#' @export
extract_session <- function(resp)
  headers(resp)$`x-ocpu-session`

#' \code{extract_svg} extracts svg
#' @inheritParams grDevices::svg
#' @rdname extract
#' @export
extract_svg <- function(resp, width = 7, height = 7) {
  if (has_pattern(resp, "graphics"))
    paste0(headers(resp)$location,
           "graphics/1/svg?width=", format(width),"&height=", format(height))
  else character(0)
}

#' \code{return} extracts the function return value
#' @rdname extract
#' @export
extract_return <- function(resp) {
  if (has_pattern(resp, ".val"))
    paste0(headers(resp)$location, "R/.val")
  else character(0)
}

has_pattern <- function(resp, pattern = "") {
  grepl(pattern, content(resp, "text"))
}
