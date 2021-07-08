
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jamesclient

<!-- badges: start -->

[![R-CMD-check](https://github.com/growthcharts/jamesclient/workflows/R-CMD-check/badge.svg)](https://github.com/growthcharts/jamesclient/actions)
<!-- badges: end -->

The goal of `jamesclient` is to facilitate interaction for `R` users
with the **Joint Automatic Measurement and Evaluation System (JAMES)**.
JAMES is an **experimental** online resource for creating and analysing
growth charts.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
install.packages("remotes")
remotes::install_github("growthcharts/jamesclient")
```

## Example

The primary functions are:

| Function           | Description                                     |
|--------------------|-------------------------------------------------|
| `upload_txt()`     | Upload and parse data for JAMES                 |
| `request_chart()`  | Upload BDS-data, draw chart with child data     |
| `inspect_upload()` | Upload demo child data and download parsed file |

### `upload_txt()`

Upload BDS data and create a tibble on the server:

``` r
library(jamesclient)
fn <- file.path(path.package("jamesclient"), "testdata", "client3.json")
r1 <- upload_txt(fn, format = 1)
browseURL(get_url(r1, "return"))
```

### `request_chart()`

Make a combined upload and automatic chartcode choice:

``` r
r2 <- request_chart(fn, chartcode = "NJAA")
browseURL(get_url(r2, "svg"))
```

### `inspect_upload()`

``` r
library(jamesclient)
head(inspect_upload(name = "Anne_S", "smocc", format = 1))
#> BDS 986 (68. Loopt los): Supplied: 3, Supplied type: character
#> 
#> BDS 986 (68. Loopt goed los): Supplied: 3, Supplied type: character
#> 
#> BDS 986 (68. Loopt soepel): Supplied: 3, Supplied type: character
#> # A tibble: 6 x 8
#>      age xname yname zname zref                       x     y     z
#>    <dbl> <chr> <chr> <chr> <chr>                  <dbl> <dbl> <dbl>
#> 1 0      age   hgt   hgt_z nl_1997_hgt_female_nl 0       51   0.052
#> 2 0.0986 age   hgt   hgt_z nl_1997_hgt_female_nl 0.0986  54.7 0.145
#> 3 0.137  age   hgt   hgt_z nl_1997_hgt_female_nl 0.137   56   0.114
#> 4 0.233  age   hgt   hgt_z nl_1997_hgt_female_nl 0.233   59.5 0.206
#> 5 0.501  age   hgt   hgt_z nl_1997_hgt_female_nl 0.501   68   0.661
#> 6 0.788  age   hgt   hgt_z nl_1997_hgt_female_nl 0.788   73   0.498
```

## Removed functions

| Function         | Description              | Alternative             |
|------------------|--------------------------|-------------------------|
| `request_site()` | Create personalised site | `james::request_site()` |
| `upload_bds()`   | Upload and parse data    | `upload_txt()`          |
