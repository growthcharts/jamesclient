library(httr)

host <- "http://localhost"
url <- file.path(host, "ocpu/library/bdsreader/examples/maria.json")
resp <- james_post(host = host, path = "data/upload/json", txt = url)$response

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
               query = list(height = 29.7/2.54, width = 21/2.54))$response),
    201)
)
