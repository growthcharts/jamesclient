#' Request chart from server
#'
#' This function assumes that the data are stored on the server.
#' @param location     An url pointing the server-side data from
#' upload.
#' @param chartcode The code of the requested growth chart. If not
#' specified, the server will automatically plot child height for
#' the most recent age period.
#' @inheritParams groeidiagrammen::draw_plot
#' @return An object of class \code{\link[httr:response]{response}}
#' @keywords client
#' @export
req_chart <- function(location, chartcode = NULL,
                      curve_interpolation = TRUE) {
  url <- "http://54.93.78.215"
  path <- "ocpu/library/james/R/draw_chart_ind"
  resp <- POST(url = url, path = path,
               body = list(location = location,
                           chartcode = chartcode,
                           curve_interpolation = curve_interpolation),
               encode = "json")

  if (http_error(resp)) {
    message_for_status(resp)
    content(resp, "text")
    return(FALSE)
  }

  if (http_type(resp) != "text/plain")
    stop("API did not return text/plain", call. = FALSE)

  resp
}
