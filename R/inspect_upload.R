#' Inspect child data uploaded to JAMES
#'
#' Uploads JSON child data to JAMES and downloads the processed data for inspection.
#' @param name Name of the child
#' @param cabinet Name of cabinet
#' @param schema Name of schema, default `bds_str`
#' @param host Full host name
#' @examples
#' data <- inspect_upload(name = "Anne_S", "smocc")
#' data
#' @export
inspect_upload <- function(name, cabinet, schema = "bds_str",
                           host = "https://groeidiagrammen.nl") {
  fn <- system.file("extdata", schema, cabinet, paste0(name, ".json"),
                    package = "jamesdemodata")
  if (fn == "") stop("Child data not found.")
  target <- readLines(con = fn)

  schema_fn <- ifelse(schema == "bds_str", "bds_schema_str.json", "bds_schema_V2.json")
  resp <- upload_txt(target,
                     host = host,
                     schema = schema_fn)
  url <- paste0(get_url(resp, "location"), "R/.val/rda")
  con <- curl::curl(url = url, open = "rb")
  on.exit(close(con))
  load(file = con)
  .val
}


