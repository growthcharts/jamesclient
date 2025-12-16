#' Make JAMES GET request
#'
#' @inheritParams james_post
#' @param \dots Extra arguments to create the URI in GET()
#' @return Object of class `james_get`
#' @export
james_get <- function(
  host = "http://localhost:8080",
  path = character(0),
  ...
) {
  ua <- user_agent(
    "https://github.com/growthcharts/jamesclient/blob/master/R/james_get.R"
  )

  # Safely build GET URL, preserving any base path in host
  parsed_host <- httr::parse_url(host)
  combined_path <- paste(parsed_host$path, path, sep = "/")
  combined_path <- gsub("//+", "/", combined_path) # Remove duplicate slashes
  url <- httr::modify_url(host, path = combined_path)

  # Get auth token from environment variable
  auth_token <- Sys.getenv("JAMES_BEARER_TOKEN", "")

  if (nchar(auth_token) > 0) {
    resp <- httr::GET(
      url,
      ua,
      httr::add_headers(Authorization = auth_token),
      ...
    )
  } else {
    resp <- httr::GET(
      url,
      ua,
      ...
    )
  }

  # parse contents
  parsed <- ""
  if (http_error(resp)) {
    msg <- content(resp, type = "text/plain", encoding = "UTF-8")
    parsed <- sprintf(
      "JAMES API request failed [%s]\n%s\n<%s>",
      status_code(resp),
      msg,
      url
    )
  } else {
    if (http_type(resp) == "application/json") {
      parsed <- jsonlite::fromJSON(content(resp, "text", encoding = "UTF-8"))
    } else {
      parsed <- content(resp, encoding = "UTF-8")
    }
  }

  # Extract session ID
  session_id <- get_url(resp, "session")

  # Build URLs for warnings and messages
  warnings <- ""
  messages <- ""

  if (!is.null(session_id) && nzchar(session_id)) {
    # Preserve base path when building session URLs
    path_w <- paste(
      parsed_host$path,
      paste0(session_id, "/warnings/text"),
      sep = "/"
    )
    path_w <- gsub("//+", "/", path_w)
    path_m <- paste(
      parsed_host$path,
      paste0(session_id, "/messages/text"),
      sep = "/"
    )
    path_m <- gsub("//+", "/", path_m)
    urlw <- httr::modify_url(host, path = path_w)
    urlm <- httr::modify_url(host, path = path_m)

    warnings <- tryCatch(
      {
        if (nchar(auth_token) > 0) {
          httr::content(
            httr::GET(urlw, httr::add_headers(Authorization = auth_token)),
            "text",
            type = "text/plain",
            encoding = "UTF-8"
          )
        } else {
          httr::content(
            httr::GET(urlw),
            "text",
            type = "text/plain",
            encoding = "UTF-8"
          )
        }
      },
      error = function(e) ""
    )

    messages <- tryCatch(
      {
        if (nchar(auth_token) > 0) {
          httr::content(
            httr::GET(urlm, httr::add_headers(Authorization = auth_token)),
            "text",
            type = "text/plain",
            encoding = "UTF-8"
          )
        } else {
          httr::content(
            httr::GET(urlm),
            "text",
            type = "text/plain",
            encoding = "UTF-8"
          )
        }
      },
      error = function(e) ""
    )
  }

  # extend standard httr response
  resp$request_path <- path
  resp$parsed <- parsed
  resp$warnings <- warnings
  resp$messages <- messages
  resp$session <- session_id

  class(resp) <- c("james_httr", "response")
  return(resp)
}
