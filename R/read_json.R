#' Read JSON content from file or URL
#'
#' Both `read_json_js()` and `read_json_jo()` read JSON from a file or an URL.
#' Function `read_json_js()` returns a string, while `read_json_jo()` returns
#' an object of class `jsonlite::class-json`.
#' @param txt A file name or URL
#' @examples
#' url <- "https://raw.githubusercontent.com/growthcharts/jamesdemodata/refs/heads/master/inst/json/examples/Laura_S.json"
#' fn <- system.file("extdata", "bds_v3.0", "smocc", "Laura_S.json",
#'  package = "jamesdemodata", mustWork = TRUE)
#'
#' js1 <- read_json_js(url)
#' js2 <- read_json_js(fn)
#' jo1 <- read_json_jo(url)
#' jo2 <- read_json_jo(fn)
#' @export
read_json_js <- function(txt = NULL) {
  if (is.null(txt)) {
    return(NULL)
  }
  stopifnot(length(txt) == 1L)
  if (validate(txt)) {
    return(txt)
  }
  if (is.url(txt) || file.exists(txt)) {
    con <- file(description = txt, open = "rt")
    on.exit(close(con))
    return(paste0(trimws(readLines(con)), collapse = ""))
  }
  return(NULL)
}

#' @rdname read_json_js
#' @export
read_json_jo <- function(txt = NULL) {
  if (is.null(txt)) {
    return(NULL)
  }
  stopifnot(length(txt) == 1L)
  if (validate(txt)) {
    return(txt)
  }
  if (is.url(txt) || file.exists(txt)) {
    return(toJSON(fromJSON(txt), auto_unbox = TRUE))
  }
  return(NULL)
}
