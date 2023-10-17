#' Upload and parse data for JAMES
#'
#' Client side upload of a JSON file, string or URL with BDS data, checks the data,
#' stores its contents as a tibble with a person attribute on host,
#' and returns an object of class [httr::response()]
#' that contains the results of the request.
#' @param verbose Logical. Print diagnostic information of POST request to console.
#' @param format String. JSON data schema version number. There are currently
#'   three schemas supported: `"1.0"`, `"1.1"`, `"2.0"` and `"3.0"`. Formats `"1.0"` and
#'   `"1.1"` are included for backward compatibility only. Use `format = "3.0"`
#'   for new applications.
#' @param schema A file name (optionally including the path) with the JSON
#'   validation schema.
#'   The `schema` argument overrides `format`. The function extracts the
#'   version number for the basename, and overwrites the
#'   `format` argument by version number.
#' @inheritParams james_post
#' @return An object of class [httr::response()]
#' @details
#' JSON format: See
#' <https://stefvanbuuren.name/jamesdocs/getting-data-into-james.html>
#' for the specification of the JSON format.
#'
#' User agent: The function `upload_txt()` searches for an object called `ua` on the search
#' list. The `ua` object is an optional user agent, a request that identifies
#' yourself to the API. For example, run
#' `httr::user_agent("https://github.com/myaccount")` (with
#' `myaccount` replaced by your github user name) before
#' calling `upload_txt()`. See
#' <https://httr.r-lib.org/articles/api-packages.html> for details. Setting
#' the user agent is not required.
#'
#' Append `"/json"` to `path` and set `query = "auto_unbox=TRUE&force=TRUE"`
#' to obtain a partial JSON representation of the S4 class `individual`. At present, it is not
#' possible to rebuild the S4 class `individual` from its JSON representation because
#' the S4 class depends on environments, and these are not converted to JSON.
#' Warning: The S4 class
#' `individual` is an internal format that is in development. It is likely to
#' change, so don't build applications based on this data structure. If you need
#' components from the internal structure (e.g. Z-scores, brokenstick estimates) it
#' is better to develop a dedicated API for obtaining these.
#' @examples
#' library(httr)
#'
#' host <- "http://localhost"
#' url <- "http://localhost/ocpu/library/bdsreader/examples/Laura_S.json"
#' fn <- system.file("extdata", "bds_v3.0", "smocc", "Laura_S.json",
#'  package = "jamesdemodata", mustWork = TRUE)
#' js <- read_json_js(url)
#' jo <- read_json_jo(url)
#'
#' # upload JSON file
#' r1 <- upload_txt(fn, host)
#' identical(status_code(r1), 201L)
#'
#' # upload JSON string
#' r2a <- upload_txt(js, host)
#' identical(status_code(r2a), 201L)
#' r2b <- upload_txt(jo, host)
#' identical(status_code(r2b), 201L)
#'
#' # upload JSON from external URL.
#' r3 <- upload_txt(url, host, format = "1.0")
#' identical(status_code(r3), 201L)
#'
#' # browseURL(file.path(get_url(r3), "print"))
#' # browseURL(file.path(get_url(r3), "json"))
#' @export
upload_txt <- function(txt,
                       host = "http://localhost",
                       format = "2.0",
                       schema = NULL,
                       verbose = FALSE) {
  path <- "ocpu/library/james/R/upload_data"
  url <- parse_url(host)
  url <- modify_url(url = url, path = file.path(url$path, path))
  done <- FALSE

  if (file.exists(txt[1L]) || is.url(txt[1L])) {
    txt <- read_json_js(txt[1L])
  }
  if (validate(txt)) {
    if (verbose) {
      resp <- POST(
        url = url,
        body = list(txt = txt),
        encode = "json", verbose())
    } else {
      resp <- POST(
        url = url,
        body = list(txt = txt),
        encode = "json")
    }
    done <- TRUE
  }

  # throw warnings and messages
  if (!done) stop("Could not upload data. Possible causes: invalid JSON or empty file.")
  url_warnings <- get_url(resp, "warnings")
  url_messages <- get_url(resp, "messages")
  if (length(url_warnings) >= 1L) {
    warning(content(GET(url_warnings), "text", encoding = "utf-8"))
  }
  if (length(url_messages) >= 1L) {
    message(content(GET(url_messages), "text", encoding = "utf-8"))
  }

  resp
}
