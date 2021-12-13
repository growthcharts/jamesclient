#' Make JAMES POST request
#'
#' @param host String with the host. The default is `"http://localhost"`
#' @param path String with the path, e.g. `"version"`, `"upload"` or `"upload/json"`
#' @param txt Data set, argument used in `[james::fetch_loc()]`
#' @param \dots Any other arguments passed to james functions via POST body
#' @return Object of class `james_post`
#' @details If `txt` is a file, then the data are uploaded using `upload_file()` and
#' encoding `multipart/form`. If `txt` is a URL, then the data are read from the URL
#' as JSON string and uploaded with encoding `json`.
#' @examples
#' url <- paste("http://localhost", "ocpu/library/jamesdemodata",
#'   "extdata/bds_v2.0/smocc/Laura_S.json", sep = "/")
#' fn <- system.file("extdata", "bds_v2.0", "smocc", "Laura_S.json",
#'  package = "jamesdemodata", mustWork = TRUE)
#' fn <- system.file("extdata", "allegrosultum", "client3.json",
#'  package = "jamesdemodata", mustWork = TRUE)
#' js <- read_json_js(txt = fn)
#' jo <- read_json_jo(txt = fn)
#'
#' #' try all inputs
#' m1 <- james_post(path = "data/upload/json", txt = fn)
#' m2 <- james_post(path = "data/upload/json", txt = js)
#' m3 <- james_post(path = "data/upload/json", txt = url)
#' @export
james_post <- function(host = "http://localhost",
                       path = character(0),
                       txt = NULL,
                       ...) {
  stopifnot(length(path) == 1L)
  url <- modify_url(url = host, path = path)
  ask_json <- grepl("/json", path)
  ua <- user_agent("https://github.com/growthcharts/jamesclient")
  stopifnot(length(txt) <= 1L)

  # if we have a file name or URL, read into string
  txt <- read_json_js(txt = txt)

  # check JSON
  if (is.null(txt) || validate(txt)) {
    resp <- POST(url, ua,
                 body = list(txt = txt,
                             ...),
                 query = list(auto_unbox = TRUE),
                 encode = "json")
  } else {
    stop("Cannot process 'txt' argument.")
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

  urlw <- file.path(host, headers(resp)$`x-ocpu-session`, "warnings")
  if (length(urlw)) {
    warnings <- content(GET(urlw), "text", type = "text/plain", encoding = "UTF-8")
  } else {
    warnings <- NULL
  }

  urlm <- file.path(host, headers(resp)$`x-ocpu-session`, "messages")
  if (length(urlm)) {
    messages <- content(GET(urlm), "text", type = "text/plain", encoding = "UTF-8")
  } else {
    messages <- NULL
  }

  structure(
    list(
      request_path = path,
      content = parsed,
      warnings = warnings,
      messages = messages,
      key = headers(resp)[["x-ocpu-session"]],
      location = headers(resp)[["location"]],
      response = resp
    ),
    class = "james_post"
  )
}

#' @export
print.james_post <- function(x, ...) {
  cat("<JAMES ", x$request_path, ">\n", sep = "")
  str(x$content)
  str(x$warnings)
  str(x$messages)
  invisible(x)
}
