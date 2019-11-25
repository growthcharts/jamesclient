context("upload BDS data")

jtf <- system.file("extdata", "test", paste0("test", 1:22, ".json"), package = "jamestest")

loader <- function(fn, local = TRUE) {
  if (local) {
    host <- "http://localhost:5656"
    path <- "ocpu/apps/stefvanbuuren/james"
  } else {
    host <- "https://groeidiagrammen.nl"
    path <- "ocpu/library/james"
  }

  r1 <- upload_bds(fn, host, path)

  return <- get_url(r1)
  ssl <- get_url(r1, "location")
  stdout <- get_url(r1, "stdout")
  console <- get_url(r1, "console")
  message <- get_url(r1, "message")

  list(return = return, location = ssl, stdout = stdout,
       console = console, message = message, resp = r1)
}

#z <- loader(jtf[4])
#stop_for_status(z[["resp"]])
#warn_for_status(z[["resp"]])
#message_for_status(z[["resp"]])

test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})
