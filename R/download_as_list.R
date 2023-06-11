#' Download results from ocpu server as a list
#'
#' Obtains the contents of one or more url's from the OpenCPU server response
#' in a list.
#' @param resp    An object of class
#'   [httr::response()], typically returned by a
#'   previous call to `httr::POST` to the server.
#' @param pattern A character vector with the trailing part of the requested
#'   url, e.g. `"R/.val"` or `"stdout"`. Use `""` to
#'   obtain all results.
#' @return A list with the contents under the url's that match
#'   `pattern`. The result has length 0 if the pattern was
#'   not found.
#' @examples
#' \dontrun{
#' fn <- system.file("testdata", "client3.json", package = "jamesclient")
#' resp <- upload_txt(fn)
#' resp
#' download_as_list(resp, pattern = "")
#' }
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
