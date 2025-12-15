# Make JAMES GET request

Make JAMES GET request

## Usage

``` r
james_get(host = "http://localhost:8080", path = character(0), ...)
```

## Arguments

- host:

  String with the host. The default is `"http://localhost:8080"`.

- path:

  String with the path to the called end point, e.g. `"version"`,
  `"data/upload"` or `"data/upload/json"`.

- ...:

  Extra arguments to create the URI in GET()

## Value

Object of class `james_get`
