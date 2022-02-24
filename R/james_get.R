#' Make JAMES GET request
#'
#' @param host String with the host. The default is `"http://localhost"`
#' @param path String with the path
#' @param \dots Extra arguments to create the URI in GET()
#' @return Object of class `james_get`
#' @export
james_get <- function(host = "http://localhost",
                      path = character(0),
                      ...) {
  url <- modify_url(url = host, path = path)
  ua <- user_agent("https://github.com/growthcharts/jamesclient/blob/master/R/james_get.R")
  ask_json <- grepl("/json", path)

  resp <- GET(url, ua, ...)

  if (ask_json) {
    if (http_type(resp) != "application/json") {
      stop("API did not return json", call. = FALSE)
    }
    parsed <- jsonlite::fromJSON(content(resp, "text", encoding = "UTF-8"))
  }

  if (!ask_json) {
    if (http_type(resp) != "text/plain") {
      stop("API did not return text", call. = FALSE)
    }
    parsed <- content(resp, "text", encoding = "UTF-8")
  }

  if (http_error(resp)) {
    message <- content(resp, type = "text/plain", encoding = "UTF-8")
    stop(
      sprintf(
        "JAMES API request failed [%s]\n%s\n<%s>",
        status_code(resp),
        message,
        url
      ),
      call. = FALSE
    )
  }

  urlw <- file.path(host, get_url(resp, "session"), "warnings/text")
  if (length(urlw)) {
    warnings <- content(GET(urlw), "text", type = "text/plain", encoding = "UTF-8")
  } else {
    warnings <- ""
  }

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
