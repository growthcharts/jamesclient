#' Inspect demo data uploaded to JAMES
#'
#' Uploads JSON child demo data to localhost and downloads the processed data
#' for inspection.
#' @param name Name of the child
#' @param cabinet Name of cabinet
#' @param format String. JSON data schema version number. There are currently
#'   three schemas supported: `"1.0"`, `"1.1"` and `"2.0"`. Formats `"1.0"` and
#'   `"1.1"` are included for backward compatibility only. Use `format = "2.0"`
#'   for new applications.
#' @inheritParams james_post
#' @examples
#' \dontrun{
#' data <- inspect_demodata(name = "Anne_S", cabinet = "smocc")
#' head(data)
#' }
#' @export
inspect_demodata <- function(name, cabinet,
                             format = c("2.0", "1.0", "1.1"),
                             host = "http://localhost",
                             mod = character(0)) {
  format <- match.arg(format)

  # fetch demodata
  fn <- system.file("extdata", paste0("bds_v", format), cabinet, paste0(name, ".json"),
                    package = "jamesdemodata", mustWork = TRUE)
  if (fn == "") stop("Child data not found.")

  target <- readLines(con = fn)
  resp <- upload_txt(txt = target,
                     host = host,
                     mod = mod,
                     format = format)
  url <- file.path(host, get_url(resp, "session"), "rda")
  con <- curl::curl(url = url, open = "rb")
  on.exit(close(con))
  load(file = con)
  .val
}
