# Get url from OpenCPU response

Get url from OpenCPU response

## Usage

``` r
get_url(
  resp,
  name = c("return", "location", "session", "console", "stdout", "svg", "svglite",
    "messages", "warnings", "json", "rda"),
  ...
)

get_url_svg(resp, pad = "?width=7&height=7", ...)
```

## Arguments

- resp:

  An object of class
  [`httr::response()`](https://httr.r-lib.org/reference/response.html)
  returned by OpenCPU.

- name:

  A string: `"return"`, `"location"`, `"session"`, `"console"`,
  `"stdout"`, `"svg"`, `"svglite"`, `"messages"`, `"warnings"`,
  `"json"`, `"rda"`. The default is `"return"`.

- ...:

  Additional string that is concatenate to the URL

- pad:

  A string to be padded to the url.

## Value

A url. If not found, the return is `character(0)`.

## Details

Only `get_url()` is exported, so use `get_url()` in your code.
