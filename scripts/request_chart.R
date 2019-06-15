# script to request growth chart from server

# first upload and translate the child growth data
library(james.client)
library(httr)
file <- file.path(path.package("james.client"), "testdata", "client3.json")
r0 <- upload_bds(file)

# default: height on PMAHN27
r1 <- request_chart(ssd = r0)
browseURL(get_url(r1, "svg"))

# request head circumference
r2 <- request_chart(ssd = r0, chartcode = "PMAON27")
browseURL(get_url(r2, "svg"))

# one chart with all three measures
r3 <- request_chart(ssd = r0, chartcode = "PJAAN27")
browseURL(get_url(r3, "svg", pad="?width=10&height=12"))
