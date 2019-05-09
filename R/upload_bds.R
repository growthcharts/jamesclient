#' Upload and parse BDS file to ocpu server
#'
#' Uploads a JSON file with \code{bds} to server, parses its contents
#' into an object of class \linkS4class{individual}, and returns the
#' file keys on the server.
#' @param fn      File name of data. The variable specification are
#'   expected to be according specification
#'   \href{https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12}{BDS
#'    JGZ 3.2.5}, and converted to JSON.
#' @param url     The \code{url} of the server
#' @return An object of class \code{\link[httr:response]{response}}
#' @examples
#' \dontrun{
#' library(james.clieny)
#' fn <- file.path(path.package("james.client"), "testdata", "client3.json")
#' resp <- upload_bds(fn)
#' resp
#' }
#' @keywords client
#' @export
upload_bds <- function(fn = NULL,
                       url = "http://54.93.78.215") {
  path <- "ocpu/library/james/R/bds_to_individual"
  dat <- upload_file(fn)
  resp <- POST(url = url, path = path, body = list(txt = dat))

  if (http_error(resp)) {
    message_for_status(resp)
    content(resp, "text")
    return(FALSE)
  }

  if (http_type(resp) != "text/plain")
    stop("API did not return text/plain", call. = FALSE)

  resp
}
