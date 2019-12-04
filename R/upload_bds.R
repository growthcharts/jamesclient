#' Upload and parse BDS file to JAMES
#'
#' Uploads a JSON file, string or URL with BDS data, checks the data,
#' stores its contents as an object of class
#' \code{\link[minihealth:individual-class]{individual}} on the server,
#' and returns an object of class \code{\link[httr:response]{response}}
#' that contains the results of the request.
#' @inheritParams request_site
#' @param path  The end point of the request, typically an R function.
#' The default is \code{path = "ocpu/library/james/R/convert_bds_ind"}
#' @param query Passed down to \code{\link[httr]{modify_url}}.
#' @return An object of class \code{\link[httr:response]{response}}
#' @details
#' JSON format: See
#' \url{https://stefvanbuuren.name/jamesdocs/getting-data-into-james.html}
#' for the specification of the JSON format.
#'
#' User agent: The function \code{upload_bds()} searches for an object called \code{ua} on the search
#' list. The \code{ua} object is an optional user agent, a request that identifies
#' yourself to the API. For example, run
#' \code{httr::user_agent("https://github.com/myaccount")} (with
#' \code{myaccount} replaced by your github user name) before
#' calling \code{upload_bds()}. See
#' \url{https://httr.r-lib.org/articles/api-packages.html} for details. Setting
#' the user agent is not required.
#'
#' Append \code{"/json"} to \code{path} and set \code{query = "auto_unbox=TRUE&force=TRUE"}
#' to obtain a partial JSON representation of the S4 class \code{individual}. At present, it is not
#' possible to rebuild the S4 class \code{individual} from its JSON representation because
#' the S4 class depends on environments, and these are not converted to JSON.
#' Warning: The S4 class
#' \code{individual} is an internal format that is in development. It is likely to
#' change, so don't build applications based on this data structure. If you need
#' components from the internal structure (e.g. Z-scores, brokenstick estimates) it
#' is better to develop a dedicated API for obtaining these.
#' @examples
#' library(httr)
#' fn  <- system.file("extdata", "allegrosultum", "client3.json", package = "jamestest")
#' js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
#' url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
#'
#' # upload JSON file
#' r1 <- upload_bds(fn)
#' identical(status_code(r1), 201L)
#'
#' # upload JSON string
#' r2 <- upload_bds(js)
#' identical(status_code(r2), 201L)
#'
#' # upload JSON from external URL
#' r3 <- upload_bds(url)
#' identical(status_code(r3), 201L)
#'
#' # just for checking: obtain the (partial) JSON representation of the uploaded data
#' path <- file.path("ocpu/library/james/R/convert_bds_ind", "json")
#' uploaded <- upload_bds(fn, path = path, query = "auto_unbox=TRUE&force=TRUE")
#'
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
  bds <- bds[[1L]]
  ua <- get0("ua", mode = "list")

  if (file.exists(bds))
    # bds is a file name
    resp <- POST(url = url,
                 body = list(txt = upload_file(bds)),
                 encode = "multipart",
                 ua,
                 add_headers(Accept = "plain/text"))
  else
    # bds is a URL or a JSON string
    resp <- POST(url = url,
                 body = list(txt = bds),
                 encode = "json",
                 ua,
                 add_headers(Accept = "plain/text"))

  # throw warnings and messages
  url_warnings <- get_url(resp, "warnings")
  url_messages <- get_url(resp, "messages")
  if (length(url_warnings) >= 1L)
    warning(content(GET(url_warnings), "text", encoding = "utf-8"))
  if (length(url_messages) >= 1L)
    message(content(GET(url_messages), "text", encoding = "utf-8"))

  # stop for unsuccesful request
  # stop_for_status(resp,
  #                 task = paste0("upload data", "\n  ",
  #                               content(resp, "text", encoding = "utf-8")))

  resp
}
