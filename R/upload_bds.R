#' Upload and parse BDS file to JAMES
#'
#' Uploads a JSON file or string with BDS-coded data, parses its
#' contents into an object of class \code{individual}. The
#' function returns various url's on the uploaded data.
#' @note At present there is only minimal error checking on the BDS file.
#' @inheritParams request_site
#' @return An object of class \code{\link[httr:response]{response}}
#' @examples
#' fn <- system.file("extdata", "allegrosultum", "client3.json", package = "jamestest")
#'
#' # upload JSON file to groeidiagrammen.nl
#' r1 <- upload_bds(fn)
#' httr::status_code(r1)
#'
#' # upload JSON file to localhost
#' host <- "http://localhost:5656"
#' path <- "ocpu/apps/stefvanbuuren/james/R/convert_bds_ind"
#' r2 <- upload_bds(fn, host = host, path = path)
#' httr::status_code(r2)
#'
#' # upload JSON string
#' js <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
#' r3 <- upload_bds(js)
#' httr::status_code(r3)
#'
#' # upload JSON from URL
#' url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
#' r4 <- upload_bds(url)
#' httr::status_code(r4)
#'
#' \dontrun{
#' # the following does not yet work
#' r5 <- upload_bds(url, host = host, path = path)
#' }
#' @seealso \code{\link[minihealth]{convert_bds_individual}},
#' \code{\link{request_site}}, \code{\link[httr:response]{response}}
#' @keywords client
#' @export
upload_bds <- function(bds,
                       host = "https://groeidiagrammen.nl",
                       path = "ocpu/library/james/R/convert_bds_ind") {

  if (file.exists(bds[1L])) {  # bds: file upload
    resp <- POST(url = host,
                 path = path,
                 body = list(txt = upload_file(bds)),
                 encode = "multipart")
  } else {    # bds: JSON string or URL
    resp <- POST(url = host,
                 path = path,
                 body = list(txt = bds),
                 encode = "json")
  }

  if (http_error(resp)) {
    cat(message_for_status(resp), "\n")
    cat(content(resp, "text", encoding = "utf-8"), "\n")
  }

  resp
}
