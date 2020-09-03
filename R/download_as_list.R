#' Download results from ocpu server as a list
#'
#' Obtains thecontents of one or more url's from the OpenCPU server response
#' in a list.
#' @param resp    An object of class
#'   \code{\link[httr:response]{response}}, typically returned by a
#'   previous call to \code{httr::POST} to the server.
#' @param pattern A character vector with the trailing part of the requested
#'   url, e.g. \code{"R/.val"} or \code{"stdout"}. Use \code{""} to
#'   obtain all results.
#' @return A list with the contents under the url's that match
#'   \code{pattern}. The result has length 0 if the pattern was
#'   not found.
#' @examples
#' file <- file.path(path.package("jamesclient"), "testdata", "client3.json")
#' resp <- upload_txt(file)
#' resp
#' download_as_list(resp, pattern = "stdout")
#' @export
download_as_list <- function(resp, pattern = "R/.val") {
  parsed <- parse_url(resp$url)
  paths <- strsplit(content(resp, "text"), "\n")[[1L]]
  idx <- grep(pattern, paths)

  if (length(idx) == 0L) {
    return(list())
  }
  v <- vector("list", length(idx))
  names(v) <- paths[idx]
  for (i in 1L:length(idx)) {
    parsed$path <- paths[idx[i]]
    url <- build_url(parsed)
    v[[i]] <- GET(url)
  }
  v
}
