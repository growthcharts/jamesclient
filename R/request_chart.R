#' Request a growth chart from groeidiagrammen.nl
#'
#' This function requests a growth chart from \code{groeidiagrammen.nl}.
#' The function assumes that the data are stored on the server.
#' @param location     An url pointing the server-side data of
#' class `individual`.
#' @param chartcode The code of the requested growth chart. If not
#' specified, the server will automatically plot child height for
#' the most recent age period.
#' @inheritParams groeidiagrammen::draw_plot
#' @return An object of class \code{\link[httr:response]{response}}
#' @seealso \code{\link[james]{draw_chart_ind}}, \code{\link[httr]{POST}}
#' @keywords client
#' @examples
#' library("james.client")
#' file <- file.path(path.package("james.client"), "testdata", "client3.json")
#' resp <- upload_bds(file)
#' loc <- extract_location(resp)
#' resp2 <- request_chart(loc, "NJAA")
#' resp2
#' @export
request_chart <- function(location, chartcode = NULL,
                          curve_interpolation = TRUE) {
  url <- "http://groeidiagrammen.nl"
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
