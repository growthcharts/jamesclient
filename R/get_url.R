#' Get url from OpenCPU response
#'
#' @param resp An object of class [httr::response()]
#' returned by OpenCPU.
#' @param name A string: `"return"`, `"location"`, `"session"`,
#'  `"console"`, `"stdout"`, `"svg"`, `"svglite"`,
#'  `"messages"`, `"warnings"`, `"json"`, `"rda"`. The default is `"return"`.
#' @param \dots Additional string that is concatenate to the URL
#' @rdname get_url
#' @return A url. If not found, the return is `character(0)`.
#' @details Only `get_url()` is exported, so use `get_url()`
#' in your code.
#' @export
get_url <- function(resp,
                    name = c(
                      "return", "location", "session",
                      "console", "stdout", "svg", "svglite",
                      "messages", "warnings", "json", "rda"
                    ),
                    ...) {
  name <- match.arg(name)
  switch(name,
    return = get_url_return(resp, ...),
    json = get_url_json(resp, ...),
    location = get_url_location(resp, ...),
    session = get_url_session(resp, ...),
    stdout = get_url_stdout(resp, ...),
    svg = get_url_svg(resp, ...),
    svglite = get_url_svglite(resp, ...),
    messages = get_url_messages(resp, ...),
    messages = get_url_warnings(resp, ...),
    console = get_url_console(resp, ...),
    rda = get_url_rda(resp, ...),
    character(0)
  )
}

get_url_location <- function(resp, ...) {
  url <- parse_url(resp$url)
  modify_url(url,
             scheme = url$scheme,
             hostname = url$hostname,
             port = url$port,
             path = paste0(get_url_session(resp), .Platform$file.sep))
}

get_url_session <- function(resp, ...) {
  headers(resp)[["x-ocpu-session"]]
}

#' @param pad A string to be padded to the url.
#' @rdname get_url
get_url_svg <- function(resp, pad = "?width=7&height=7", ...) {
  if (has_pattern(resp, "graphics")) {
    paste0(get_url_location(resp), "graphics/1/svg", pad)
  } else {
    character(0)
  }
}

get_url_svglite <- function(resp, pad = "?width=7&height=7", ...) {
  if (has_pattern(resp, "graphics")) {
    paste0(get_url_location(resp), "graphics/1/svglite", pad)
  } else {
    character(0)
  }
}

get_url_return <- function(resp, ...) {
  if (has_pattern(resp, ".val")) {
    paste0(get_url_location(resp), "R/.val")
  } else {
    character(0)
  }
}

get_url_json <- function(resp, ...) {
  if (has_pattern(resp, ".val")) {
    paste0(get_url_location(resp), "R/.val/json")
  } else {
    character(0)
  }
}

get_url_rda <- function(resp, ...) {
  if (has_pattern(resp, ".val")) {
    paste0(get_url_location(resp), "R/.val/rda")
  } else {
    character(0)
  }
}


get_url_stdout <- function(resp, ...) {
  if (has_pattern(resp, "stdout")) {
    paste0(get_url_location(resp), "stdout")
  } else {
    character(0)
  }
}

get_url_console <- function(resp, ...) {
  if (has_pattern(resp, "console")) {
    paste0(get_url_location(resp), "console")
  } else {
    character(0)
  }
}

get_url_messages <- function(resp, ...) {
  if (has_pattern(resp, "message")) {
    paste0(get_url_location(resp), "messages")
  } else {
    character(0)
  }
}
get_url_warnings <- function(resp, ...) {
  if (has_pattern(resp, "warnings")) {
    paste0(get_url_location(resp), "warnings")
  } else {
    character(0)
  }
}


has_pattern <- function(resp, pattern = "") {
  grepl(pattern, content(resp, "text"))
}
