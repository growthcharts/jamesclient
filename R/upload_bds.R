#' Upload and parse BDS file to JAMES
#'
#' Uploads a JSON file with \code{bds} to server, parses its contents
#' into an object of class \linkS4class{individual}, and returns the
#' result urls on the server.
#' @note At present there is only minimal error checking on the BDS file.
#' @param file      File name of data. The variable specification are
#'   expected to be according specification
#'   \href{https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12}{BDS
#'    JGZ 3.2.5}, and converted to JSON.
#' @param host     The \code{url} of the server, which defaults to
#' \code{http://groeidiagrammen.nl}.
#' @return An object of class \code{\link[httr:response]{response}}
#' that can be used as input for \code{request_chart()}
#' @examples
#' library(jamesclient)
#' file <- file.path(path.package("jamesclient"), "testdata", "client3.json")
#' resp <- upload_bds(file)
#' resp
#' @keywords client
#' @export
upload_bds <- function(file,
                       host = "http://groeidiagrammen.nl") {
  dat <- upload_file(file)
  resp <- POST(url = host,
               path = "ocpu/library/james/R/convert_bds_ind",
               body = list(txt = dat))

  if (http_error(resp)) {
    message_for_status(resp)
    content(resp, "text")
    return(FALSE)
  }

  if (http_type(resp) != "text/plain")
    stop("API did not return text/plain", call. = FALSE)

  resp
}
