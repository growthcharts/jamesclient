#' Inspect child data uploaded to JAMES
#'
#' Uploads JSON child demo data to JAMES and downloads the processed data for inspection.
#' @param name Name of the child
#' @param cabinet Name of cabinet
#' @param host Full host name
#' @inheritParams bdsreader::set_schema
#' @examples
#' data <- inspect_upload(name = "Anne_S", "smocc", format = "2.0", host = "http://localhost")
#' head(data)
#' @export
inspect_upload <- function(name, cabinet,
                           format = c("2.0", "1.0", "1.1"),
                           host = "https://groeidiagrammen.nl") {
  format <- match.arg(format)

  # fetch demodata
  fn <- system.file("extdata", paste0("bds_v", format), cabinet, paste0(name, ".json"),
                    package = "jamesdemodata", mustWork = TRUE)
  if (fn == "") stop("Child data not found.")

  target <- readLines(con = fn)
  resp <- upload_txt(txt = target,
                     host = host,
                     format = format)
  url <- paste0(get_url(resp, "location"), "R/.val/rda")
  con <- curl::curl(url = url, open = "rb")
  on.exit(close(con))
  load(file = con)
  .val
}


