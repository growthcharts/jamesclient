#' Upload and parse data for JAMES
#'
#' Client side upload of a JSON file, string or URL with BDS data, checks the data,
#' stores its contents as a tibble with a person attribute on host,
#' and returns an object of class [httr::response()]
#' that contains the results of the request.
#' @param txt A JSON string, URL or file with the data in JSON
#' format. The input data adhere to specification
#' [BDS JGZ 3.2.5](https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12),
#' and are converted to JSON according to `schema`.
#' @param host String with URL of the JAMES host machine. Defaults to
#' `https://groeidiagrammen.nl`.
#' @inheritParams bdsreader::set_schema
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
#' \dontrun{
#' library(httr)
#' fn <- system.file("extdata", "bds_v1.0", "smocc", "Laura_S.json", package = "jamesdemodata")
#' js <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
#'
#' url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
#' host <- "https://groeidiagrammen.nl"
#' # host <- "http://localhost"
#'
#' # upload JSON file
#' r1 <- upload_txt(fn, host, format = 1)
#' identical(status_code(r1), 201L)
#'
#' # upload JSON string
#' r2 <- upload_txt(js, host, format = 1)
#' identical(status_code(r2), 201L)
#'
#' # upload JSON from external URL
#' r3 <- upload_txt(url, host, format = 1)
#' identical(status_code(r3), 201L)
#' }
#' @export
upload_txt <- function(txt,
                       host = "https://groeidiagrammen.nl",
                       format = 2L,
                       schema = NULL) {
  schema_list <- set_schema(format, schema)
  schema <- schema_list$schema_base
  format <- schema_list$format

  # FIXME
  # remove next schema overwrite below after API update
  schema <- "bds_schema_str.json"

  url <- modify_url(url = host, path = "ocpu/library/james/R/fetch_loc")
  txt <- txt[[1L]]
  ua <- get0("ua", mode = "list")
  try.error <- FALSE

  if (file.exists(txt)) {
    # txt is a file name: upload
    writeLines(jsonlite::toJSON(list(schema = unbox(schema))), schema)
    resp <- POST(
      url = url,
      body = list(txt = upload_file(txt),
                  schema = upload_file(schema)),
      encode = "multipart",
      ua,
      add_headers(Accept = "plain/text")
    )
    unlink(schema)
  } else {
    # txt is a URL: overwrite txt with JSON string
    if (!validate(txt)) {
      con.url <- try(con <- url(txt, open = "rb"), silent = TRUE)
      try.error <- inherits(con.url, "try-error")
      if (!try.error) {
        txt <- toJSON(fromJSON(txt, flatten = TRUE), auto_unbox = TRUE)
        close(con)
      }
    }
    # txt is JSON string: upload
    resp <- POST(
      url = url,
      body = list(txt = txt, schema = schema),
      encode = "json",
      ua,
      add_headers(Accept = "plain/text")
    )
  }

  # throw warnings and messages
  if (try.error) warning("Data URL not found (404)")
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
