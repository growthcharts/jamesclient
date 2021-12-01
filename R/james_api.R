#' Make JAMES GET request
#'
#' @param path String with the path
#' @return Object of class `james_get`
#' @export
james_get <- function(path) {
  url <- modify_url("http://localhost", path = path)
  ua <- user_agent("https://github.com/growthcharts/jamesclient")

  resp <- GET(url, ua)
  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

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

  structure(
    list(
      content = parsed,
      path = path,
      response = resp
    ),
    class = "james_get"
  )
}

print.james_get <- function(x, ...) {
  cat("<JAMES ", x$path, ">\n", sep = "")
  str(x$content)
  invisible(x)
}
