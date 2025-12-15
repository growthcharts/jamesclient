#' Upload BDS JSON Data to JAMES Server
#'
#' Uploads and validates BDS data from a JSON file, URL, or string, sends it to a
#' JAMES server, and returns the server response. On success, the data is stored
#' as a tibble with a person attribute on the host.
#'
#' @param txt The input data to upload. Can be a local JSON file path, a URL
#'   pointing to JSON data, or a JSON string or object.
#' @param host Character. URL of the JAMES server. Default: `"http://localhost:8080"`.
#' @param format Character. JSON schema version number. Supported formats are
#'   `"1.0"`, `"1.1"`, `"2.0"`, and `"3.0"`. Format `"3.0"` is recommended.
#'   If `schema` is provided, it overrides `format`.
#' @param schema Optional character. File path to a JSON schema for validation.
#'   Overrides `format`. The version number is extracted from the file name.
#' @param verbose Logical. If `TRUE`, prints diagnostic output of the POST request.
#'
#' @return An object of class [httr::response()] containing the server's response.
#'
#' @details
#' If an object named `ua` (a user agent created via [httr::user_agent()])
#' exists in the environment, it will be added to the request headers.
#' While optional, identifying yourself can be useful for diagnostics.
#'
#' To retrieve a partial JSON representation of the internal S4 class `individual`,
#' append `"/json"` to the `path` and set `query = list(auto_unbox = TRUE, force = TRUE)`.
#' Note: This representation is not intended for reconstructing the class, and may
#' change without notice. Use dedicated APIs to access internal data elements such
#' as Z-scores or brokenstick estimates.
#'
#' @examples
#' host <- "https://james.groeidiagrammen.nl"
#' url <- paste0("https://raw.githubusercontent.com/growthcharts/jamesdemodata/",
#'               "refs/heads/master/inst/json/examples/Laura_S.json")
#' fn <- system.file("extdata", "bds_v3.0", "smocc", "Laura_S.json",
#'                   package = "jamesdemodata", mustWork = TRUE)
#' js <- read_json_js(url)
#' jo <- read_json_jo(url)
#'
#' r1 <- upload_txt(fn, host)
#' stopifnot(httr::status_code(r1) == 201L)
#'
#' r2a <- upload_txt(js, host)
#' r2b <- upload_txt(jo, host)
#'
#' r3 <- upload_txt(url, host, format = "1.0")
#' stopifnot(httr::status_code(r3) == 201L)
#'
#' # View server response URLs
#' # browseURL(file.path(get_url(r3), "print"))
#' # browseURL(file.path(get_url(r3), "json"))
#'
#' @export
upload_txt <- function(
  txt,
  host = "http://localhost:8080",
  format = "3.0",
  schema = NULL,
  verbose = FALSE
) {
  # Define target API endpoint
  path <- "ocpu/library/james/R/upload_data"
  url <- httr::modify_url(host, path = path)

  # Read JSON if txt is file or URL
  if (file.exists(txt[1L]) || is.url(txt[1L])) {
    txt <- read_json_js(txt[1L])
  }

  # Validate JSON
  if (!validate(txt)) {
    stop("Could not upload data. Invalid JSON or empty input.")
  }

  # Prepare request
  body <- list(txt = txt)
  ua <- if (exists("ua", inherits = TRUE)) get("ua", inherits = TRUE) else NULL

  # Make POST request
  resp <- if (verbose) {
    httr::POST(url, body = body, encode = "json", ua, httr::verbose())
  } else {
    httr::POST(url, body = body, encode = "json", ua)
  }

  # Fetch and print server warnings/messages if any
  session <- get_url(resp, "session")
  if (!is.null(session) && nzchar(session)) {
    url_warnings <- httr::modify_url(
      host,
      path = paste0(session, "/warnings/text")
    )
    url_messages <- httr::modify_url(
      host,
      path = paste0(session, "/messages/text")
    )

    msg <- tryCatch(
      httr::content(
        httr::GET(url_messages, config = httr::config()),
        "text",
        encoding = "UTF-8"
      ),
      error = function(e) NULL
    )
    warn <- tryCatch(
      httr::content(
        httr::GET(url_warnings, config = httr::config()),
        "text",
        encoding = "UTF-8"
      ),
      error = function(e) NULL
    )

    if (!is.null(msg) && nzchar(msg)) {
      message(msg)
    }
    if (!is.null(warn) && nzchar(warn)) warning(warn)
  }

  resp
}
