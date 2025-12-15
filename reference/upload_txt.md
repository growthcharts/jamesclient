# Upload BDS JSON Data to JAMES Server

Uploads and validates BDS data from a JSON file, URL, or string, sends
it to a JAMES server, and returns the server response. On success, the
data is stored as a tibble with a person attribute on the host.

## Usage

``` r
upload_txt(
  txt,
  host = "http://localhost:8080",
  format = "3.0",
  schema = NULL,
  verbose = FALSE
)
```

## Arguments

- txt:

  The input data to upload. Can be a local JSON file path, a URL
  pointing to JSON data, or a JSON string or object.

- host:

  Character. URL of the JAMES server. Default:
  `"http://localhost:8080"`.

- format:

  Character. JSON schema version number. Supported formats are `"1.0"`,
  `"1.1"`, `"2.0"`, and `"3.0"`. Format `"3.0"` is recommended. If
  `schema` is provided, it overrides `format`.

- schema:

  Optional character. File path to a JSON schema for validation.
  Overrides `format`. The version number is extracted from the file
  name.

- verbose:

  Logical. If `TRUE`, prints diagnostic output of the POST request.

## Value

An object of class
[`httr::response()`](https://httr.r-lib.org/reference/response.html)
containing the server's response.

## Details

If an object named `ua` (a user agent created via
[`httr::user_agent()`](https://httr.r-lib.org/reference/user_agent.html))
exists in the environment, it will be added to the request headers.
While optional, identifying yourself can be useful for diagnostics.

To retrieve a partial JSON representation of the internal S4 class
`individual`, append `"/json"` to the `path` and set
`query = list(auto_unbox = TRUE, force = TRUE)`. Note: This
representation is not intended for reconstructing the class, and may
change without notice. Use dedicated APIs to access internal data
elements such as Z-scores or brokenstick estimates.

## Examples

``` r
host <- "https://james.groeidiagrammen.nl"
url <- paste0("https://raw.githubusercontent.com/growthcharts/jamesdemodata/",
              "refs/heads/master/inst/json/examples/Laura_S.json")
fn <- system.file("extdata", "bds_v3.0", "smocc", "Laura_S.json",
                  package = "jamesdemodata", mustWork = TRUE)
js <- read_json_js(url)
jo <- read_json_jo(url)

r1 <- upload_txt(fn, host)
stopifnot(httr::status_code(r1) == 201L)

r2a <- upload_txt(js, host)
r2b <- upload_txt(jo, host)

r3 <- upload_txt(url, host, format = "1.0")
stopifnot(httr::status_code(r3) == 201L)

# View server response URLs
# browseURL(file.path(get_url(r3), "print"))
# browseURL(file.path(get_url(r3), "json"))
```
