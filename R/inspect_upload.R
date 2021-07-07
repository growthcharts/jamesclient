#' Inspect child data uploaded to JAMES
#'
#' Uploads JSON child data to JAMES and downloads the processed data for inspection.
#' @param name Name of the child
#' @param cabinet Name of cabinet
#' @param host Full host name
#' @inheritParams bdsreader::set_schema
#' @examples
#' data <- inspect_upload(name = "Anne_S", "smocc", version = 1)
#' head(data)
#' @export
inspect_upload <- function(name, cabinet,
                           version = 2L,
                           host = "https://groeidiagrammen.nl") {
  schema_path <- switch(version, "bds_v1.0", "bds_v2.0")
  fn <- system.file("extdata", schema_path, cabinet, paste0(name, ".json"),
                    package = "jamesdemodata")
  if (fn == "") stop("Child data not found.")

  target <- readLines(con = fn)
  resp <- upload_txt(target,
                     host = host,
                     version = version)
  url <- paste0(get_url(resp, "location"), "R/.val/rda")
  con <- curl::curl(url = url, open = "rb")
  on.exit(close(con))
  load(file = con)
  .val
}


