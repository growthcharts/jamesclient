library(httr)

#start_url <- "http://54.93.249.213/ocpu/library/stats/R/rnorm?n=3"
#p_url <-parse_url(start_url)

# define server url
ip <- "54.93.249.213"
url <- paste0("http://", ip)

# submit GET request - list libraries
path <- "ocpu/library"
r <- GET(url = url, path = path)

# submit POST - with body
path <- "/ocpu/library/stats/R/rnorm"
query <- list(n = 3)
r <- POST(url = url, path = path, body = query, encode = "json")
r2 <- GET(url = url, path = "/ocpu/tmp/x0d9541debb10a7/stdout")

content(GET(url = url, path = strsplit(content(r, "text"), "\n")[[1]][3]))
