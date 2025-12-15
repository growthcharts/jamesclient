# Read JSON content from file or URL

Both `read_json_js()` and `read_json_jo()` read JSON from a file or an
URL. Function `read_json_js()` returns a string, while `read_json_jo()`
returns an object of class `jsonlite::class-json`.

## Usage

``` r
read_json_js(txt = NULL)

read_json_jo(txt = NULL)
```

## Arguments

- txt:

  A file name or URL

## Examples

``` r
url <- paste0(
  "https://raw.githubusercontent.com/growthcharts/jamesdemodata/",
  "refs/heads/master/inst/json/examples/Laura_S.json")
fn <- system.file("extdata", "bds_v3.0", "smocc", "Laura_S.json",
 package = "jamesdemodata", mustWork = TRUE)

js1 <- read_json_js(url)
js2 <- read_json_js(fn)
jo1 <- read_json_jo(url)
jo2 <- read_json_jo(fn)
```
