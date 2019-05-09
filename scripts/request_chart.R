# script to request growth chart from server

# first upload and translate the child growth data
library(gateway)
library(httr)
fn <- file.path(path.package("gateway"), "testdata", "client3.json")
resp <- upload_bds(fn)
loc <- extract_location(resp)

# create the chart

resp2 <- req_chart(location = loc, chartcode = "WMAH")
browseURL(extract_svg(resp2))

resp2 <- req_chart(location = loc, chartcode = "PJAAN27")
browseURL(extract_svg(resp2, width = 10, height = 12))

chartbox::list_charts()

# use function that uploads and process data
