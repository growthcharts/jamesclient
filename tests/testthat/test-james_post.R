library(httr)

host <- "http://localhost"
# host <- "https://james.groeidiagrammen.nl"
url <- file.path(host, "ocpu/library/bdsreader/examples/maria.json")

if (valid_url(host) && valid_url(url)) {
  resp <- james_post(host = host, path = "data/upload/json", txt = url)

  test_that(
    "Uploads using data/upload/json endpoint",
    expect_equal(status_code(resp), 201)
  )

  test_that(
    "Reads data from previous location with loc",
    expect_equal(status_code(
      james_post(host = host, path = "/charts/draw/svglite",
                 loc = resp$location,
                 chartcode = "PMAAN27", selector = "chartcode",
                 query = list(height = 29.7/2.54, width = 21/2.54))),
      201)
  )

  test_that(
    "Reads data from previous location with session",
    expect_equal(status_code(
      james_post(host = host, path = "/charts/draw/svglite",
                 session = resp$session,
                 chartcode = "PMAAN27", selector = "chartcode",
                 query = list(height = 29.7/2.54, width = 21/2.54))),
      201)
  )
}

if (valid_url(host) && valid_url(url)) {
  fn <- system.file("extdata/bds_v2.0/smocc/laura_s.json", package = "jamesdemodata")
  # fn <- system.file("extdata/bds_v2.0/test/test1.json", package = "jamesdemodata")
  js <- read_json_js(fn)
  resp <- james_post(host = host, path = "data/upload/json", txt = js)
  test_that(
    "Download demodata file",
    expect_equal(status_code(resp), 201)
  )
}
