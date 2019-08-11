#' Upload and parse BDS file to JAMES
#'
#' Uploads a JSON file or string with BDS-coded data, parses its
#' contents into an object of class \code{individual}. The
#' function returns various url's on the uploaded data.
#' @note At present there is only minimal error checking on the BDS file.
#' @inheritParams request_site
#' @return An object of class \code{\link[httr:response]{response}}
#' @examples
#' library(jamesclient)
#'
#' # upload as JSON file
#' fn <- file.path(path.package("jamesclient"), "testdata", "client3.json")
#' r1 <- upload_bds(fn)
#' get_url(r1, "return")
#'
#'\dontrun{
#' # upload as JSON string
#' data("installed.cabinets", package = "jamestest")
#' ind <- installed.cabinets[[3]][[4]]
#' js <- minihealth::convert_individual_bds(ind)
#' r2 <- upload_bds(js)
#' get_url(r2, "return")
#' }
#' @seealso \code{\link[minihealth]{convert_bds_individual}},
#' \code{\link{request_site}}, \code{\link[httr:response]{response}}
#' @keywords client
#' @export
upload_bds <- function(bds,
                       host = "https://groeidiagrammen.nl",
                       path = "ocpu/library/james") {

  if (file.exists(bds)) {  # file
    dat <- upload_file(bds)
    resp <- POST(url = host,
                 path = paste(path, "R/convert_bds_ind", sep = "/"),
                 body = list(txt = dat),
                 encode = "multipart")
  }
  if (validate(bds)) {    # JSON string
    body <- list(txt = bds)
    resp <- POST(url = host,
                 path = paste(path, "R/convert_bds_ind", sep = "/"),
                 body = body,
                 encode = "json")
  }

  if (http_error(resp)) {
    cat(message_for_status(resp), "\n")
    cat(content(resp, "text", encoding = "utf-8"), "\n")
  }

  if (http_type(resp) != "text/plain")
    stop("API did not return text/plain", call. = FALSE)

  resp
}
