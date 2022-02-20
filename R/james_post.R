#' Make JAMES POST request
#'
#' @param host String with the host. The default is `"http://localhost"`
#' @param path String with the path, e.g. `"version"`, `"upload"` or `"upload/json"`
#' @param query A list with query arguments, for example, `list(auto_unbox = TRUE)` for
#' `json` output, or `list(width = 7.09, height = 7.09)` for `svglite`.
#' @param txt Data set, argument used in `[james::upload_data()]`
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
#'
#' \dontrun{
#' # create and store A4 SVG plot
#' r5 <- james_post(path = "/charts/draw/svglite", txt = url,
#' chartcode = "NMBA", selector = "chartcode",
#' query = list(height = 29.7/2.54, width = 21/2.54))
#' tmp <- tempfile(pattern = "chart", fileext = ".svg")
#' writeLines(r5$content, con = tmp)
#' browseURL(tmp)
#' unlink(tmp)
#' }
#' @export
james_post <- function(host = "http://localhost",
                       path = character(0),
                       query = list(),
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
                 query = query,
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

  parsed <- NULL
  if (http_type(resp) == "application/json") {
    parsed <- jsonlite::fromJSON(content(resp, "text", encoding = "UTF-8"))
  }

  if (http_type(resp) == "text/plain") {
    parsed <- content(resp, "text", encoding = "UTF-8")
  }

  if (http_type(resp) == "image/svg+xml") {
    parsed <- content(resp, "text", encoding = "UTF-8")
  }

  if (is.null(parsed)) {
    parsed <- content(resp, as = "parsed")
  }

  urlw <- file.path(host, get_url(resp, "session"), "warnings")
  if (length(urlw)) {
    warnings <- content(GET(urlw), "text", type = "text/plain", encoding = "UTF-8")
  } else {
    warnings <- NULL
  }

  urlm <- file.path(host, get_url(resp, "session"), "messages")
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
      session = get_url(resp, "session"),
      location = get_url(resp, "location"),
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
