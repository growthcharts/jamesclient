# script to request growth chart from server

# first upload and translate the child growth data
library(james.client)
library(httr)
file <- file.path(path.package("james.client"), "testdata", "client3.json")
resp <- upload_bds(file)
loc <- extract_location(resp)

# create the chart

resp2 <- req_chart(location = loc, chartcode = "WMAH")
browseURL(extract_svg(resp2))

resp2 <- req_chart(location = loc, chartcode = "PJAAN27")
browseURL(extract_svg(resp2, width = 10, height = 12))

# list the available charts
# POST(paste0(resp$url

# use function that uploads and process data
