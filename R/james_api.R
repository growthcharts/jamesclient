#' Make JAMES GET request
#'
#' @param host String with the host. The default is `"http://localhost"`
#' @param path String with the path
#' @return Object of class `james_get`
#' @export
james_get <- function(host = "http://localhost",
                      path = character(0)) {
  url <- modify_url(hostname = host, path = path)
  ua <- user_agent("https://github.com/growthcharts/jamesclient")
  ask_json <- grepl("/json", path)

  resp <- GET(url, ua)

  parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)

  if (status_code(resp) != 200) {
    stop(
      sprintf(
        "JAMES API request failed [%s]\n%s\n<%s>",
        status_code(resp),
        parsed$message,
        parsed$documentation_url
      ),
      call. = FALSE
    )
  }

  if (ask_json && http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  structure(
    list(
      request_path = path,
      content = parsed,
      response = resp
    ),
    class = "james_get"
  )
}

print.james_get <- function(x, ...) {
  cat("<JAMES ", x$request_path, ">\n", sep = "")
  str(x$content)
  invisible(x)
}
