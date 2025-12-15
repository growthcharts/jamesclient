# Inspect demo data uploaded to JAMES

Uploads JSON child demo data to localhost and downloads the processed
data for inspection.

## Usage

``` r
inspect_demodata(
  name,
  cabinet,
  format = c("3.0", "2.0", "1.0", "1.1"),
  host = "http://localhost:8080"
)
```

## Arguments

- name:

  Name of the child

- cabinet:

  Name of cabinet

- format:

  String. JSON data schema version number. There are currently three
  schemas supported: `"1.0"`, `"1.1"` and `"2.0"`. Formats `"1.0"` and
  `"1.1"` are included for backward compatibility only. Use
  `format = "2.0"` for new applications.

- host:

  String with the host. The default is `"http://localhost:8080"`.

## Examples

``` r
if (FALSE) { # \dontrun{
data <- inspect_demodata(name = "Anne_S", cabinet = "smocc")
head(data)
} # }
```
