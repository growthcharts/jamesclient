#' Get url from OpenCPU response
#'
#' @param resp An object of class \code{\link[httr:response]{response}}
#' returned by OpenCPU.
#' @param name A string: \code{"location"}, \code{"session"},
#' \code{"stdout"}, \code{"svg"} or \code{"return"}. The default is
#' \code{"return"}.
#' @param \dots Additional string that is concatenate to the URL
#' @rdname get_url
#' @return A url. If not found, the return is \code{character(0)}.
#' @details Only \code{get_url()} is exported, so use \code{get_url()}
#' in your code.
#' @export
get_url <- function(resp,
                    name = c("return", "location", "session",
                             "stdout", "svg"),
                    ...) {
  name <- match.arg(name)
  switch(name,
         return = get_url_return(resp, ...),
         location = get_url_location(resp, ...),
         session = get_url_session(resp, ...),
         stdout = get_url_stdout(resp, ...),
         svg = get_url_svg(resp, ...),
         character(0))
}

get_url_location <- function(resp, ...)
  headers(resp)$location

get_url_session <- function(resp, ...)
  headers(resp)$`x-ocpu-session`

#' @param pad A string to be padded to the url.
#' @rdname get_url
get_url_svg <- function(resp, pad = "?width=7&height=7", ...) {
  if (has_pattern(resp, "graphics"))
    paste0(headers(resp)$location, "graphics/1/svg", pad)
  else character(0)
}

get_url_return <- function(resp, ...) {
  if (has_pattern(resp, ".val"))
    paste0(headers(resp)$location, "R/.val")
  else character(0)
}

get_url_stdout <- function(resp, ...) {
  if (has_pattern(resp, "stdout"))
    paste0(headers(resp)$location, "stdout")
  else character(0)
}


has_pattern <- function(resp, pattern = "") {
  grepl(pattern, content(resp, "text"))
}


