#' Make JAMES POST request
#'
#' @param path String with the path
#' @param txt Data set, used in `upload`
#' @return Object of class `james_post`
#' @details If `txt` is a file, then the data are uploaded using `upload_file()` and
#' encoding `multipart/form`. If `txt` is a URL, then the data are read from the URL
#' as JSON string and uploaded with encoding `json`.
#' @examples
#' fn <- system.file("extdata", "allegrosultum", "client3.json", package = "jamesdemodata")
#' url <- paste("http://localhost", "ocpu/library/jamesdemodata",
#'   "extdata/bds_v2.0/smocc/Laura_S.json", sep = "/")
#' fn1 <- system.file("extdata", "bds_v2.0", "smocc", "Laura_S.json",
#'  package = "jamesdemodata", mustWork = TRUE)
#' js1 <- readLines(url)
#' js2 <- jsonlite::toJSON(jsonlite::fromJSON(url), auto_unbox = TRUE)
#'
#' #' try all four inputs
#' m1 <- james_post("upload", txt = fn1)
#' m2 <- james_post("upload", txt = js1)
#' m3 <- james_post("upload", txt = js2)
#' m4 <- james_post("upload", txt = url)
#' @export
james_post <- function(path = c("version",
                                "upload"),
                       txt = NULL) {
  host <- "http://localhost"
  path <- file.path(match.arg(path), "json")
  url <- modify_url(url = host, path = path)
  ua <- user_agent("https://github.com/growthcharts/jamesclient")
  done <- FALSE

  txt <- txt[1L]
  # if we have a file name, request encode = "multipart"
  if (file.exists(txt)) {
    resp <- POST(url, ua,
                 body = list(txt = upload_file(txt)),
                 encode = "multipart")
    done <- TRUE
  }
  # if we have a URL, read as json string
  if (url.exists(txt)) {
    con <- curl(txt, open = "r")
    txt <- readLines(con)
    close(con)
  }
  # if we have valid JSON, request encode = "json"
  if (!done) {
    if (validate(txt)) {
      resp <- POST(url, ua,
                   body = list(txt = txt),
                   query = list(auto_unbox = TRUE),
                   encode = "json")
    } else {
      stop("Cannot process 'txt' argument.")
    }
  }

  if (http_type(resp) != "application/json") {
    message <- content(resp, type = "text/plain", encoding = "UTF-8")
    stop(
      sprintf(
        "API did not return json [%s]\n%s\n<%s>",
        status_code(resp),
        message,
        url),
      call. = FALSE)
  }

  parsed <- jsonlite::fromJSON(content(resp, "text", encoding = "UTF-8"))
  if (status_code(resp) != 201) {
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
      content = parsed,
      warnings = warnings,
      messages = messages,
      path = path,
      key = headers(resp)$`x-ocpu-session`,
      response = resp
    ),
    class = "james_post"
  )
}

#' @export
print.james_post <- function(x, ...) {
  cat("<JAMES ", x$path, ">\n", sep = "")
  str(x$content)
  str(x$warnings)
  str(x$messages)
  invisible(x)
}
