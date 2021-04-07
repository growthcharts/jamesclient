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
#' @inheritParams james::draw_chart
#' @return An object of class [httr::response()]
#' @seealso [james::draw_chart()], [upload_txt()].
#' @keywords client
#' @details
#' One of `txt` or `resp` need to be specified. If both
#' are given, a non-NULL `txt` takes precedence over `resp`.
#' @examples
#' # example with separate upload
#' fn <- file.path(path.package("jamesclient"), "testdata", "client3.json")
#' resp1 <- upload_txt(fn)
#' loc <- get_url(resp1, "loc")
#' resp2 <- request_chart(loc = loc, chartcode = "NJAA")
#' url <- get_url(resp2, "svglite")
#' # browseURL(url)
#'
#' # example with integrated upload and automatic chartcode choice
#' resp3 <- request_chart(fn)
#' @export
request_chart <- function(txt = NULL,
                          loc = NULL,
                          chartcode = NULL,
                          curve_interpolation = TRUE) {
  url <- "https://groeidiagrammen.nl"

  # upload the data to server and draw graph
  if (!is.null(txt)) {
    path <- "ocpu/library/james/R/draw_chart"
    resp <- POST(
      url = url, path = path,
      body = list(
        txt = upload_file(txt),
        chartcode = chartcode,
        curve_interpolation = curve_interpolation
      )
    )
  }

  # read the data from the server-side location
  if (is.null(txt)) {
    stopifnot(!is.null(loc))
    path <- "ocpu/library/james/R/draw_chart"
    resp <- POST(
      url = url, path = path,
      body = list(
        loc = loc,
        chartcode = chartcode,
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
