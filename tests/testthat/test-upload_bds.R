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
# status_code(r)
#
# the following does not yet work
# r5 <- upload_bds(url, host = host, path = path)

jtf <- system.file("extdata", "test", paste0("test", 1:23, ".json"), package = "jamestest")

test_that("test1.json (client3.json) uploads",
          expect_equal(status_code(upload_bds(jtf[1], host = host, path = path)), 201))

test_that("test2.json (missing referentie) PASSES",
          expect_equal(status_code(upload_bds(jtf[2], host = host, path = path)), 201))

test_that("test3.json (missing OrganisatieCode) FAILS",
          expect_error(upload_bds(jtf[3], host = host, path = path), class = "http_400"))

test_that("test4.json (wrong type) FAILS",
          expect_error(upload_bds(jtf[4], host = host, path = path), class = "http_400"))

test_that("test5.json (missing ClientGegevens) FAILS",
          expect_error(upload_bds(jtf[5], host = host, path = path), class = "http_400"))

test_that("test6.json (Missing ContactMomenten) PASSES",
          expect_equal(status_code(upload_bds(jtf[6], host = host, path = path)), 201))

test_that("test7.json (Missing Referentie & OrganisatieCode) FAILS",
          expect_error(upload_bds(jtf[7], host = host, path = path), class = "http_400"))

test_that("test8.json returns error message",
          expect_error(upload_bds(jtf[8], host = host, path = path), class = "http_400"))

test_that("test9.json (Bdsnummer 19 missing) FAILS",
          expect_error(upload_bds(jtf[9], host = host, path = path), class = "http_400"))

test_that("test10.json (Bdsnummer 20 missing) FAILS",
          expect_error(upload_bds(jtf[10], host = host, path = path), class = "http_400"))

test_that("test11.json (Bdsnummer 82 missing) PASSES",
          expect_equal(status_code(upload_bds(jtf[11], host = host, path = path)), 201L))

test_that("test12.json (Bdsnummer 91 missing) PASSES",
          expect_equal(status_code(upload_bds(jtf[12], host = host, path = path)), 201L))

test_that("test13.json (Bdsnummer 110 missing) PASSES",
          expect_equal(status_code(upload_bds(jtf[13], host = host, path = path)), 201L))

test_that("test14.json return error message",
          expect_error(upload_bds(jtf[14], host = host, path = path), class = "http_400"))

test_that("test15.json (Bdsnummer 19 numeric) PASSES with message",
          expect_message(upload_bds(jtf[15], host = host, path = path),
                         '[{"bdsnummer":19,"description":"Sex of child","expected":"one of: 0, 1, 2, 3","supplied":"2","supplied_type":"numeric"},{"bdsnummer":62,"description":"Caretaker relation","expected":"one of: 01, 02, 03, 04, 05, 06, 07, 08, 98","supplied":"1","supplied_type":"numeric"}]'))

test_that("test16.json (Bdsnummer 20 numeric) PASSES",
          expect_equal(status_code(upload_bds(jtf[16], host = host, path = path)), 201L))

test_that("test17.json (Bdsnummer 82 numeric) PASSES",
          expect_equal(status_code(upload_bds(jtf[17], host = host, path = path)), 201L))

test_that("test18.json (Bdsnummer 91 numeric) FAILS",
          expect_message(upload_bds(jtf[18], host = host, path = path),
                         '[{"bdsnummer":91,"description":"Smoking during pregnancy","expected":"one of: 1, 2, 99","supplied":"1","supplied_type":"numeric"}]'))

test_that("test19.json (Bdsnummer 110 numeric) PASSES",
          expect_equal(status_code(upload_bds(jtf[19], host = host, path = path)), 201L))

test_that("test20.json (missing Groepen) PASSES",
          expect_equal(status_code(upload_bds(jtf[20], host = host, path = path)), 201L))

test_that("test21.json (minimal data) PASSES",
          expect_equal(status_code(upload_bds(jtf[21], host = host, path = path)), 201L))

test_that("test22.json (range checking) PASSES",
          expect_equal(status_code(upload_bds(jtf[22], host = host, path = path)), 201L))

test_that("test23.json (multiple messages) PASSES",
          expect_message(upload_bds(jtf[23], host = host, path = path),
                         '[{"bdsnummer":91,"description":"Smoking during pregnancy","expected":"one of: 1, 2, 99","supplied":"1","supplied_type":"numeric"}]'))


fn  <- system.file("extdata", "smocc", "Laura_S.json", package = "jamestest")
js  <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

host <- "http://vps.stefvanbuuren.nl"

test_that("Laura_S.json file uploads to vps.stefvanbuuren.nl",
          expect_equal(status_code(upload_bds(fn, host = host)), 201))

test_that("Laura_S.json file uploads to vps.stefvanbuuren.nl",
          expect_equal(status_code(upload_bds(js, host = host)), 201))
