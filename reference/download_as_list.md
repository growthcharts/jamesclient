# Download results from ocpu server as a list

Obtains the contents of one or more url's from the OpenCPU server
response in a list.

## Usage

``` r
download_as_list(resp, pattern = "R/.val")
```

## Arguments

- resp:

  An object of class
  [`httr::response()`](https://httr.r-lib.org/reference/response.html),
  typically returned by a previous call to
  [`httr::POST`](https://httr.r-lib.org/reference/POST.html) to the
  server.

- pattern:

  A character vector with the trailing part of the requested url, e.g.
  `"R/.val"` or `"stdout"`. Use `""` to obtain all results.

## Value

A list with the contents under the url's that match `pattern`. The
result has length 0 if the pattern was not found.

## Examples

``` r
if (FALSE) { # \dontrun{
fn <- system.file("testdata", "client3.json", package = "jamesclient")
resp <- upload_txt(fn)
resp
download_as_list(resp, pattern = "")
} # }
```
