#' Make JAMES GET request
#'
#' @inheritParams james_post
#' @param \dots Extra arguments to create the URI in GET()
#' @return Object of class `james_get`
#' @export
james_get <- function(host = "http://localhost",
                      path = character(0),
                      auth = NULL,
                      ...) {
  ua <- user_agent("https://github.com/growthcharts/jamesclient/blob/master/R/james_get.R")
  url <- parse_url(host)
  url <- modify_url(url = url, path = file.path(url$path, path))
  if (!is.null(auth)) {
    headers <- add_headers("Authorization" = paste("Bearer", auth))
  } else headers <- add_headers

  resp <- GET(url, ua, headers, ...)

  # parse contents
  parsed <- ""
  if (http_error(resp)) {
    msg <- content(resp, type = "text/plain", encoding = "UTF-8")
    parsed <- sprintf(
      "JAMES API request failed [%s]\n%s\n<%s>",
      status_code(resp), msg, url)
  } else {

    if (http_type(resp) == "application/json") {
      parsed <- jsonlite::fromJSON(content(resp, "text", encoding = "UTF-8"))
    } else {
      parsed <- content(resp, encoding = "UTF-8")
    }
  }

  # extract warnings
  urlw <- file.path(host, get_url(resp, "session"), "warnings/text")
  if (length(urlw)) {
    warnings <- content(GET(urlw), "text", type = "text/plain", encoding = "UTF-8")
  } else {
    warnings <- ""
  }

  # extract messages
  urlm <- file.path(host, get_url(resp, "session"), "messages/text")
  if (length(urlm)) {
    messages <- content(GET(urlm), "text", type = "text/plain", encoding = "UTF-8")
  } else {
    messages <- ""
  }

  # extend standard httr response
  resp$request_path <- path
  resp$parsed <- parsed
  resp$warnings <- warnings
  resp$messages <- messages
  resp$session <- get_url(resp, "session")

  class(resp) <- c("james_httr", "response")
  return(resp)
}
