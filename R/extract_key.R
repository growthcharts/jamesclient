#' Extract location of the response on the server
#'
#' @param resp An object of class \code{\link[httr:response]{response}}
#' @return A url
#' @keywords client
#' @rdname extract
#' @export
extract_location <-
  function(resp) headers(resp)$location

#' Extract svg url on OpenCPU server
#'
#' @inheritParams grDevices::svg
#' @return A url
#' @keywords client
#' @rdname extract
#' @export
extract_svg <- function(resp, width = 7, height = 7) {
  if (has_pattern(resp, "graphics"))
    paste0(headers(resp)$location,
           "graphics/1/svg?width=", format(width),"&height=", format(height))
  else character(0)
}

has_pattern <- function(resp, pattern = "") {
  grepl(pattern, content(resp, "text"))
}
