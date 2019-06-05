# This script tests whether opencpu is running on groeidiagrammen.nl
library(httr)

start_url <- "http://groeidiagrammen.nl/ocpu/library/stats/R/rnorm?n=3"
p_url <-parse_url(start_url)

# define server url
ip <- "groeidiagrammen.nl"
url <- paste0("http://", ip)

# submit GET request - list libraries
path <- "ocpu/library"
r <- GET(url = url, path = path)

# submit POST - with body
path <- "/ocpu/library/stats/R/rnorm"
query <- list(n = 3)
r <- POST(url = url, path = path, body = query, encode = "json")

content(GET(url = url, path = strsplit(content(r, "text"), "\n")[[1]][3]))
