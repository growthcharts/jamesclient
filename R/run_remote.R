run_remote <- function(hostname = "groeidiagrammen.nl",
                       scheme = "http",
                       pkg = "stats",
                       func = "rnorm",
                       param = list(n = 3)) {
  url <- paste0(scheme, "://", hostname)
  path <- paste0("ocpu/library/", pkg, "/R/", func)
  resp <- POST(url = url, path = path, body = param)

  if (http_error(resp)) {
    stop(message_for_status(resp), call. = FALSE)
  }

  if (http_type(resp) != "text/plain") {
    stop("API did not return text/plain", call. = FALSE)
  }

  url2 <- paste0(
    url,
    strsplit(content(resp, "text"), "\n")[[1L]][1L],
    "/json"
  )
  x <- fromJSON(url2)
  x
}

# run_remote()
# run_remote(func = "rbinom", param = list(n = 5, size = 1, prob = 0.8))
# run_remote(func = "hist", param = list(x = mtcars$mpg))
# run_remote(pkg = "MASS", func = "get", param = list(x = "outer"))
