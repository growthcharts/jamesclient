#' Request site containing personalised charts
#'
#' This function constructs a URL to a site that shows a personalised
#' growth chart. The site includes a nagivation bar so that the end
#' user can tweak chart choice.
#' @param bds File name or a string referring to the data (in JSON
#'   format) to be uploaded. The variable specification are expected
#'   to be according specification
#'   \href{https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12}{BDS
#'    JGZ 3.2.5}, and converted to JSON.
#' @param ssd Server-side data location, for example, as obtained
#' by \code{get_url(resp, "location")}, where \code{resp} is the
#' \code{\link[httr:response]{response}} object returned OpenCPU.
#' @param host String with URL of the JAMES host machine. Defaults to
#' \code{https://groeidiagrammen.nl}.
#' @param path Path to JAMES application on host. Defaults to
#' \code{ocpu/library/james}.
#' @return URL composed of JAMES server and query string starting
#' with \code{?ind=...}, which indicates the URL of the uploaded
#' child data
#' @seealso \code{\link{upload_bds}}, \code{\link{get_url}}
#' @keywords client
#' @details
#' The function can take child data in two forms: 1) a JSON file with
#' BDS-formatted child data (argument \code{bds}) or, 2) a URL with
#' child data on a previously stored server location on the server
#' (argument \code{ssd}).
#'
#' One of \code{bds} or \code{ssd} need to be specified. If both
#' are given, \code{bds} takes precedence.
#' @note We upload the data to groeidiagrammen.nl (the default)
#' since localhost does not handle url's to local uploads.
#' See examples.
#' @examples
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
#' # request_site does not work on localhost, presumably
#' # because the local machine does not run a full webserver
#' # however, if file is uploaded to groeidiagrammen.nl,
#' # then the localhost can download data from there
#'
#' # --- this does not work
#' r1 <- upload_bds(fn,
#'                  host = "http://localhost:5656",
#'                  path = "ocpu/apps/stefvanbuuren/james")
#' ssd <- get_url(r1, "location")
#' site_url <- request_site(ssd = ssd,
#'                          host = "http://localhost:5656",
#'                          path = "ocpu/apps/stefvanbuuren/james")
#' site_url
#' # browseURL(site_url)
#'
#' # --- this will work
#' r1 <- upload_bds(fn)
#' ssd <- get_url(r1, "location")
#' site_url <- request_site(ssd = ssd,
#'                          host = "http://localhost:5656",
#'                          path = "ocpu/apps/stefvanbuuren/james")
#' site_url
#' # browseURL(site_url)
#'}
#' @export
request_site <- function(bds = NULL,
                         ssd  = NULL,
                         host = "https://groeidiagrammen.nl",
                         path = "ocpu/library/james") {
  app <- paste(host, path, "www/", sep = "/")

  # upload the data if needed, and get url to individual data
  if (!is.null(bds)) {
    resp <- upload_bds(bds)
    if (!http_error(resp)) ssd <- get_url(resp, "location")
  }

  # return url to personalised site
  if (is.null(ssd)) param <- character(0)
  else param <- paste("?ind", ssd, sep = "=")
  paste0(app, param)
}
