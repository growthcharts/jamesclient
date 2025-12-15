# Request a growth chart from JAMES

This function requests a growth chart from `groeidiagrammen.nl`. The
function can upload a JSON file with BDS-format to the server, parse its
contents into a tibble with a person attribute, and draw the plot. The
user may skip uploading, and use a previously stored location on the
server.

## Usage

``` r
request_chart(
  txt = NULL,
  loc = NULL,
  host = "https://groeidiagrammen.nl",
  chartcode = NULL,
  selector = NULL,
  curve_interpolation = TRUE
)
```

## Arguments

- txt:

  A JSON string, URL or file with the data in JSON format. The input
  data adhere to specification [BDS JGZ
  3.2.5](https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12),
  and are converted to JSON according to `schema`.

- loc:

  Alternative to `txt`. Location where input data is uploaded and
  converted to internal server format.

- host:

  The host to which to upload

- chartcode:

  The code of the requested growth chart. If not specified, the server
  will automatically plot child height for the most recent age period.

- selector:

  Either `"chartcode"`, `"data"` or `"derive"`. See
  `james::draw_chart()` docs for more detail.

- curve_interpolation:

  Logical. Smooth growth curve along centiles?

## Value

An object of class
[`httr::response()`](https://httr.r-lib.org/reference/response.html)

## Details

One of `txt` or `resp` need to be specified. If both are given, a
non-NULL `txt` takes precedence over `resp`.

## See also

[`upload_txt()`](https://growthcharts.org/jamesclient/reference/upload_txt.md).

## Examples

``` r
# examples with direct uploads
url <- paste0(
  "https://raw.githubusercontent.com/growthcharts/jamesdemodata/",
  "refs/heads/master/inst/json/examples/client3.json")
fn <- system.file("testdata", "client3.json", package = "jamesclient")
host <- "https://james.groeidiagrammen.nl"

# request default chart (PMAHN27)
resp1 <- request_chart(url, host = host)
# browseURL(get_url(resp1, "svglite"))

# request 30 weeks chart ((PMAHN30)
resp2 <- request_chart(url, host = host, chartcode = "PMAHN30")
resp3 <- request_chart(fn, host = host, chartcode = "PMAHN30")
js <- read_json_js(fn)
resp4 <- request_chart(js, host = host, chartcode = "PMAHN30")
jo <- read_json_jo(fn)
resp5 <- request_chart(jo, host = host, chartcode = "PMAHN30")

# in two steps: first upload then request chart
resp6 <- upload_txt(fn, host = host)
#> BDS 82 (Gestational age in days): Outside range 50-350
loc <- get_url(resp6, "loc")
resp7 <- request_chart(loc = loc, host = host, chartcode = "PMAHN30")
```
