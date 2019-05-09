#' Extract url of function return on server
#'
#' @param resp      An object of class \code{\link[httr:response]{response}}
#' @return A url ending in \code{"R/.val"}
#' @keywords client
#' @export
extract_return_url <- function(resp) {
  paste0(headers(resp)$location, "R/.val")
}
