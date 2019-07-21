#' Request a site personalised chart and user nagivation
#'
#' This function requests an URL to a site that shows a personalised
#' growth chart plus essential user nagivation from JANES. The
#' function can take child data in two forms: 1) a JSON file with
#' BDS-formatted child data or, 2) a URL with child data on a
#' previously stored server location on the server.
#' @param bds Name of file that contains valid JSON data. The
#'   variable specification are expected to be according specification
#'   \href{https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12}{BDS
#'    JGZ 3.2.5}, and converted to JSON.
#' @param ssd Server-side data location, for example, as obtained
#' by \code{get_url(resp, "location")}, where \code{resp} is the
#' object returned by OpenCPU server.
#' @param host A url of the JAMES server host.
#' @param path Path to application on JAMES server.
#' @inheritParams james::draw_chart
#' @return An object of class \code{\link[httr:response]{response}}
#' @seealso \code{\link[james]{draw_chart}},
#' \code{\link{upload_bds}}.
#' @keywords client
#' @details
#' One of \code{txt} or \code{resp} need to be specified. If both
#' are given, a non-NULL \code{txt} takes precedence over \code{resp}.
#' @examples
#' # example with separate upload
#' library("jamesclient")
#' fn <- file.path(path.package("jamesclient"), "testdata", "client3.json")
#'
#' # as two steps
#' resp <- upload_bds(fn)
#' ssd <- get_url(resp, "location")
#' site_url <- request_site(ssd = ssd)
#' site_url
#' # browseURL(site_url)
#'
#' # into one step
#' site_url <- request_site(bds = fn)
#' site_url
#'
#' \dontrun{
#' # using localhost
#' r1 <- upload_bds(fn,
#'                  host = "http://localhost:5656",
#'                  path = "ocpu/apps/stefvanbuuren/james")
#' get_url(r1, "return")
#'}
#' @export
request_site <- function(bds = NULL,
                         ssd  = NULL,
                         host = "http://groeidiagrammen.nl",
                         path = "ocpu/library/james") {
  app <- paste(host, path, "www/", sep = "/")

  # upload the data if needed, and get url to individual data
  if (!is.null(bds)) {
    resp <- upload_bds(bds, host, path)
    if (!http_error(resp)) ssd <- get_url(resp, "location")
  }

  stopifnot(!is.null(ssd))

  # return url to personalised site
  param <- paste("ind", ssd, sep = "=")
  paste(app, param, sep = "?")
}

