library(httr)

fn <- system.file("extdata", "allegrosultum", "client3.json", package = "jamesdemodata")
js1 <- read_json_js(fn)
js2 <- read_json_jo(fn)
url <- "https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"
url <- "https://james.groeidiagrammen.nl/ocpu/library/james/testdata/client3.json"

hosts <- c("https://james.groeidiagrammen.nl",
           "http://localhost")

for (host in hosts) {
  if (valid_url(host)) {
    test_that(
      paste("fn uploads to host", host),
      expect_equal(status_code(upload_txt(fn, host = host)), 201)
    )
    test_that(
      paste("js1 uploads to host", host),
      expect_equal(status_code(upload_txt(js1, host = host)), 201)
    )
    test_that(
      paste("js2 uploads to host", host),
      expect_equal(status_code(upload_txt(js2, host = host)), 201)
    )
    test_that(
      paste("url uploads to host", host),
      expect_equal(status_code(upload_txt(url, host = host)), 201)
    )
  }
}

host3 <- hosts[2]
if (valid_url(host3)) {
  for (format in c("1.0", "2.0")) {
    jtf <- system.file("extdata", paste0("bds_v", format), "test", paste0("test", 1:23, ".json"), package = "jamesdemodata")

    test_that(
      "test2.json (missing referentie) PASSES",
      expect_equal(status_code(upload_txt(jtf[2], host = host3)), 201)
    )

    test_that(
      "test3.json (missing OrganisatieCode) PASSES",
      expect_equal(status_code(upload_txt(jtf[3], host = host3)), 201)
    )

    test_that(
      "test4.json (wrong type) PASSES",
      expect_equal(status_code(upload_txt(jtf[4], host = host3)), 201)
    )

    test_that(
      "test5.json (missing ClientGegevens) PASSES",
      expect_equal(status_code(upload_txt(jtf[5], host = host3)), 201)
    )

    test_that(
      "test6.json (Missing ContactMomenten) PASSES",
      expect_equal(status_code(upload_txt(jtf[6], host = host3)), 201)
    )

    test_that(
      "test7.json (Missing Referentie & OrganisatieCode) PASSES",
      expect_equal(status_code(upload_txt(jtf[7], host = host3)), 201)
    )

    test_that(
      "test8.json (Invalid OrganisatieCode)",
      expect_error(upload_txt(jtf[8], host = host3))
    )

    test_that(
      "test9.json (Bdsnummer 19 missing) PASSES",
      expect_equal(status_code(upload_txt(jtf[9], host = host3)), 201)
    )

    test_that(
      "test10.json (Bdsnummer 20 missing) PASSES",
      expect_equal(status_code(upload_txt(jtf[10], host = host3)), 201)
    )

    test_that(
      "test11.json (Bdsnummer 82 missing) PASSES",
      expect_equal(status_code(upload_txt(jtf[11], host = host3)), 201L)
    )

    test_that(
      "test12.json (Bdsnummer 91 missing) PASSES",
      expect_equal(status_code(upload_txt(jtf[12], host = host3)), 201L)
    )

    test_that(
      "test13.json (Bdsnummer 110 missing) PASSES",
      expect_equal(status_code(upload_txt(jtf[13], host = host3)), 201L)
    )

    test_that(
      "test14.json (Empty file)",
      expect_error(upload_txt(jtf[8], host = host3))
    )

    test_that(
      "test15.json (Bdsnummer 19 numeric) PASSES",
      expect_equal(status_code(upload_txt(jtf[15], host = host3)), 201L)
    )

    test_that(
      "test16.json (Bdsnummer 20 numeric) PASSES",
      expect_equal(status_code(upload_txt(jtf[16], host = host3)), 201L)
    )

    test_that(
      "test17.json (Bdsnummer 82 numeric) PASSES",
      expect_equal(status_code(upload_txt(jtf[17], host = host3)), 201L)
    )

    test_that(
      "test18.json (Bdsnummer 91 numeric) PASSES",
      expect_equal(status_code(upload_txt(jtf[18], host = host3)), 201L)
    )

    test_that(
      "test19.json (Bdsnummer 110 numeric) PASSES",
      expect_equal(status_code(upload_txt(jtf[19], host = host3)), 201L)
    )

    test_that(
      "test20.json (missing Groepen) PASSES",
      expect_equal(status_code(upload_txt(jtf[20], host = host3)), 201L)
    )

    test_that(
      "test21.json (minimal data) PASSES",
      expect_equal(status_code(upload_txt(jtf[21], host = host3)), 201L)
    )

    test_that(
      "test22.json (range checking) PASSES",
      expect_equal(status_code(upload_txt(jtf[22], host = host3)), 201L)
    )

    test_that(
      "test23.json (multiple messages) PASSES",
      expect_message(
        upload_txt(jtf[23], host = host3),
        '[{"bdsnummer":91,"description":"Smoking during pregnancy","expected":"one of: 1, 2, 99","supplied":"1","supplied_type":"numeric"}]'
      )
    )
  }

  fn <- system.file("extdata", "bds_v2.0", "smocc", "Laura_S.json", package = "jamesdemodata")
  js <- jsonlite::toJSON(jsonlite::fromJSON(fn), auto_unbox = TRUE)

  test_that(
    "Laura_S.json file uploads",
    expect_equal(status_code(upload_txt(fn, host = host3)), 201)
  )

  test_that(
    "Laura_S js string uploads",
    expect_equal(status_code(upload_txt(js, host = host3)), 201)
  )
}
