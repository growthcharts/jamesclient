#' Upload and parse BDS file to JAMES
#'
#' Uploads a JSON file or string with BDS-coded data, parses its
#' contents into an object of class \code{individual}. The
#' function returns various url's on the uploaded data.
#' @note At present there is only minimal error checking on the BDS file.
#' @inheritParams request_site
#' @param query Passed down to \code{\link[httr]{modify_url}}.
#' @return An object of class \code{\link[httr:response]{response}}
#' @details
#' Append \code{"/json"} to \code{path} and set \code{query = "auto_unbox=TRUE&force=TRUE"}
#' to obtain a partial JSON representation of the S4 class \code{individual}. At present, it is not
#' possible to rebuild the S4 class individual from its JSON representation because
#' the S4 class depends on environments, and these are not converted to JSON.
#' @examples
#' library(httr)
#' fn  <- system.file("extdata", "allegrosultum", "client3.json", package = "jamestest")
#' js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
#' url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
#'
#' # upload JSON file
#' r1 <- upload_bds(fn)
#' identical(status_code(r1), 201)
#'
#' # upload JSON string
#' r2 <- upload_bds(js)
#' identical(status_code(r2), 201)
#'
#' # upload JSON from external URL
#' r3 <- upload_bds(url)
#' identical(status_code(r3), 201)
#'
#' # obtain the (partial) JSON representation of the uploaded data
#' path <- file.path("ocpu/library/james/R/convert_bds_ind", "json")
#' uploaded <- upload_bds(fn, path = path, query = "auto_unbox=TRUE&force=TRUE")
#' \dontrun{
#' # upload to localhost
#' host <- "http://localhost:5656"
#' path <- "ocpu/apps/stefvanbuuren/james/R/convert_bds_ind"
#'
#' r4 <- upload_bds(fn, host = host, path = path)
#' status_code(r4)
#'
#' r5 <- upload_bds(js, host = host, path = path)
#' status_code(r5)
#'
#' # uploading url to localhost does not work:
#' r6 <- upload_bds(url, host = host, path = path)
#' status_code(r6)
#' }
#' @seealso \code{\link[minihealth]{convert_bds_individual}},
#' \code{\link{request_site}}, \code{\link[httr:response]{response}}
#' @keywords client
#' @export
upload_bds <- function(bds,
                       host = "https://groeidiagrammen.nl",
                       path = "ocpu/library/james/R/convert_bds_ind",
                       query = NULL) {

  url <- modify_url(url = host, path = path, query = query)

  if (file.exists(bds[1L]))
    # bds is a file upload
    resp <- POST(url = url,
                 body = list(txt = upload_file(bds)),
                 encode = "multipart")
  else
    # bds is a JSON string or URL
    resp <- POST(url = url,
                 body = list(txt = bds),
                 encode = "json")

  if (http_error(resp)) {
    cat(message_for_status(resp), "\n")
    cat(content(resp, "text", encoding = "utf-8"), "\n")
  }

  resp
}
