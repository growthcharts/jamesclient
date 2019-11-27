context("upload BDS data")

library(httr)

fn  <- system.file("extdata", "allegrosultum", "client3.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)
url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"

host <- "https://groeidiagrammen.nl"
path <- "ocpu/library/james/R/convert_bds_ind"

test_that("client3.json file uploads to groeidiagrammen.nl",
          expect_equal(status_code(upload_bds(fn, host = host, path = path)), 201))
test_that("JSON string uploads to groeidiagrammen.nl",
          expect_equal(status_code(upload_bds(js, host = host, path = path)), 201))
test_that("JSON file at URL uploads to groeidiagrammen.nl",
          expect_equal(status_code(upload_bds(url, host = host, path = path)), 201))

# run the following only if localhost is running
host <- "http://localhost:5656"
path <- "ocpu/apps/stefvanbuuren/james/R/convert_bds_ind"
# upload JSON file to localhost
# r <- upload_bds(fn, host = host, path = path)
# httr::status_code(r)
#
# the following does not yet work
# r5 <- upload_bds(url, host = host, path = path)

jtf <- system.file("extdata", "test", paste0("test", 1:22, ".json"), package = "jamestest")

test_that("test1.json (client3.json) uploads",
          expect_equal(status_code(upload_bds(jtf[1], host = host, path = path)), 201))

test_that("test3.json (missing OrganisatieCode) FAILS",
          expect_equal(status_code(upload_bds(jtf[3], host = host, path = path)), 400))

test_that("test4.json (wrong type) FAILS",
          expect_equal(status_code(upload_bds(jtf[4], host = host, path = path)), 400))

test_that("test8.json (wrong type) FAILS",
          expect_equal(status_code(upload_bds(jtf[8], host = host, path = path)), 400))

test_that("test12.json (BDS 91 missing) PASSES, with messages",
          expect_equal(status_code(upload_bds(jtf[12], host = host, path = path)), 201))

test_that("test18.json (BDS 91 numeric) PASSES, with messages",
          expect_equal(status_code(upload_bds(jtf[18], host = host, path = path)), 201))

# cat(httr::content(z$resp, type = "text", encoding = "UTF-8"))
