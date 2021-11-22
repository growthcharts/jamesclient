#' Request a growth chart from JAMES
#'
#' This function requests a growth chart from
#' `groeidiagrammen.nl`. The function can upload a JSON file
#' with BDS-format to the server, parse its contents into a tibble with
#' a person attribute, and draw the plot.
#' The user may skip uploading, and use a previously stored
#' location on the server.
#' @param txt A JSON string, URL or file with the data in JSON
#' format. The input data adhere to specification
#' [BDS JGZ 3.2.5](https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12),
#' and are converted to JSON according to `schema`.
#' @param loc Alternative to `txt`. Location where input data is uploaded
#' and converted to internal server format.
#' @param chartcode The code of the requested growth chart. If not
#' specified, the server will automatically plot child height for
#' the most recent age period.
#' @param selector See [james::draw_chart()].
#' @param curve_interpolation Logical. Smooth growth curve along centiles?
#' @return An object of class [httr::response()]
#' @seealso [upload_txt()].
#' @keywords client
#' @details
#' One of `txt` or `resp` need to be specified. If both
#' are given, a non-NULL `txt` takes precedence over `resp`.
#' @examples
#' # examples with direct uploads
#' url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
#' fn <- system.file("testdata", "client3.json", package = "jamesclient")
#' js <- readLines(fn)
#'
#' # request default chart (PMAHN27)
#' resp1 <- request_chart(url)
#' # browseURL(get_url(resp1, "svglite"))
#'
#' # request 30 weeks chart ((PMAHN30)
#' resp2 <- request_chart(url, chartcode = "PMAHN30")
#' resp3 <- request_chart(fn, chartcode = "PMAHN30")
#' resp4 <- request_chart(js, chartcode = "PMAHN30")
#'
#' # example with upload then chart
#' resp5 <- upload_txt(fn)
#' loc <- get_url(resp5, "loc")
#' resp6 <- request_chart(loc = loc, chartcode = "PMAHN30")
#' @export
request_chart <- function(txt = NULL,
                          loc = NULL,
                          chartcode = NULL,
                          selector = NULL,
                          curve_interpolation = TRUE) {
  url <- "http://localhost"
  path <- "ocpu/library/james/R/draw_chart"
  done <- FALSE
  if (is.null(selector)) {
    selector <- ifelse(is.null(chartcode), "data", "chartcode")
  }

  if (!is.null(txt)) {
    # read file if txt is a filename or URL
    if (file.exists(txt[1L]) || url.exists(txt[1L])) {
      txt <- readLines(txt)
    }
    # txt is JSON string: upload and draw
    if (validate(txt)) {
      resp <- POST(
        url = url, path = path,
        body = list(txt = txt,
                    chartcode = chartcode,
                    selector = selector,
                    curve_interpolation = curve_interpolation),
        encode = "json")
      done <- TRUE
    }
  } else {
    # read the data from the server-side location
    stopifnot(!is.null(loc))
    resp <- POST(
      url = url, path = path,
      body = list(
        loc = loc,
        chartcode = chartcode,
        selector = selector,
        curve_interpolation = curve_interpolation
      ),
      encode = "json"
    )
  }

  if (http_error(resp)) {
    message_for_status(resp)
    content(resp, "text")
    return(FALSE)
  }

  if (http_type(resp) != "text/plain") {
    stop("API did not return text/plain", call. = FALSE)
  }

  resp
}
