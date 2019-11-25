#' Request a growth chart from JAMES
#'
#' This function requests a growth chart from
#' \code{groeidiagrammen.nl}. The function can upload a JSON file
#' with BDS-format to the server, parse its contents into an object of
#' class \code{individual}, and draw the plot.
#' The user may skip uploading, and use a previously stored
#' location on the server.
#' @param file File name of data. The variable specification are
#'   expected to be according specification
#'   \href{https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12}{BDS
#'    JGZ 3.2.5}, and converted to JSON.
#' @param ssd Server-side data. An object of class
#'   \code{\link[httr:response]{response}} containing an url that
#'   points to server-side data of class `individual`, for example,
#'   created by a call to \code{upload_bds()}.
#' @param chartcode The code of the requested growth chart. If not
#' specified, the server will automatically plot child height for
#' the most recent age period.
#' @inheritParams james::draw_chart
#' @return An object of class \code{\link[httr:response]{response}}
#' @seealso \code{\link[james]{draw_chart}}, \code{\link{upload_bds}}.
#' @keywords client
#' @details
#' One of \code{file} or \code{resp} need to be specified. If both
#' are given, a non-NULL \code{file} takes precedence over \code{resp}.
#' @examples
#' # example with separate upload
#' library("jamesclient")
#' file <- file.path(path.package("jamesclient"), "testdata", "client3.json")
#' data <- upload_bds(file)
#' resp1 <- request_chart(ssd = data, chartcode = "NJAA")
#'
#' # example with integrated upload and automatic chartcode choice
#' resp2 <- request_chart(file = file)
#' @export
request_chart <- function(file = NULL,
                          ssd  = NULL,
                          chartcode = NULL,
                          curve_interpolation = TRUE) {
  url <- "https://groeidiagrammen.nl"

  # upload the data to server and draw graph
  if (!is.null(file)) {
    path <- "ocpu/library/james/R/draw_chart_bds"
    dat <- upload_file(file)
    resp <- POST(url = url, path = path,
                 body = list(txt = dat,
                             chartcode = chartcode,
                             curve_interpolation = curve_interpolation))
  }

  # read the data from the server-side location
  if (is.null(file)) {
    stopifnot(!is.null(ssd))
    path <- "ocpu/library/james/R/draw_chart_ind"
    location <- get_url(ssd, "location")
    resp <- POST(url = url, path = path,
                 body = list(ind_loc = location,
                             chartcode = chartcode,
                             curve_interpolation = curve_interpolation),
                 encode = "json")
  }

  if (http_error(resp)) {
    message_for_status(resp)
    content(resp, "text")
    return(FALSE)
  }

  if (http_type(resp) != "text/plain")
    stop("API did not return text/plain", call. = FALSE)

  resp
}
