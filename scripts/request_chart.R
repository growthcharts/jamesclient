# script to request growth chart from server

# first upload and translate the child growth data
library(james.client)
library(httr)
file <- file.path(path.package("james.client"), "testdata", "client3.json")
resp <- upload_bds(file)
loc <- get_url(resp, "location")

# create the chart

resp2 <- request_chart(ssd = resp, chartcode = "WMAH")
browseURL(get_url(resp2, "svg"))

resp2 <- request_chart(ssd = resp, chartcode = "PJAAN27")
browseURL(get_url(resp2, "svg", pad="?width=10&height=12"))
