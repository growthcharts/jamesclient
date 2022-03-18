
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jamesclient

<!-- badges: start -->

[![R-CMD-check](https://github.com/growthcharts/jamesclient/workflows/R-CMD-check/badge.svg)](https://github.com/growthcharts/jamesclient/actions)
<!-- badges: end -->

The goal of `jamesclient` is to facilitate interaction for `R` users
with the **Joint Automatic Measurement and Evaluation System (JAMES)**.
JAMES is an online resource for creating growth charts and analysing
growth curves.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
install.packages("remotes")
remotes::install_github("growthcharts/jamesclient")
```

## Example

The primary functions are:

| Function             | Description                                     |
|----------------------|-------------------------------------------------|
| `james_post`         | Send POST request to JAMES                      |
| `james_get`          | Send GET request to JAMES                       |
| `inspect_demodata()` | Upload demo child data and download parsed file |

### `james_post()`

Upload BDS data

``` r
library(jamesclient)
fn <- system.file("extdata", "allegrosultum", "client3.json", 
                  package = "jamesdemodata", mustWork = TRUE)
host <- "https://james.groeidiagrammen.nl"
r1 <- james_post(host = host, path = "data/upload/json", txt = fn)
r1$parsed
#> $psn
#>   id                                 name        dob       dobf       dobm  src
#> 1 -1 fa308134-069e-49ce-9847-ccdae380ed6f 2018-10-11 1995-07-04 1990-12-02 1234
#>      sex gad ga smo  bw hgtm hgtf agem etn
#> 1 female 189 27   1 990  167  190   27  NL
#> 
#> $xyz
#>       age xname yname zname                  zref       x     y      z
#> 1  0.0849   age   hgt hgt_z nl_2012_hgt_female_27  0.0849 38.00 -0.158
#> 2  0.1670   age   hgt hgt_z nl_2012_hgt_female_27  0.1670 43.50  0.047
#> 3  0.0849   age   wgt wgt_z nl_2012_wgt_female_27  0.0849  1.25 -0.203
#> 4  0.1670   age   wgt wgt_z nl_2012_wgt_female_27  0.1670  2.10  0.015
#> 5  0.0849   age   hdc hdc_z nl_2012_hdc_female_27  0.0849 27.00 -0.709
#> 6  0.1670   age   hdc hdc_z nl_2012_hdc_female_27  0.1670 30.50 -0.913
#> 7  0.0849   age   bmi bmi_z nl_1997_bmi_female_nl  0.0849  8.66 -5.719
#> 8  0.1670   age   bmi bmi_z nl_1997_bmi_female_nl  0.1670 11.10 -3.767
#> 9  0.0849   hgt   wfh wfh_z   nl_2012_wfh_female_ 38.0000  1.25 -0.001
#> 10 0.1670   hgt   wfh wfh_z   nl_2012_wfh_female_ 43.5000  2.10  0.326
#> 11 0.0000   age   wgt wgt_z nl_2012_wgt_female_27  0.0000  0.99  0.190
```

### `james_get()`

Get output from R console (just for checking)

``` r
r2 <- james_get(host = host, path = paste(r1$session, "console", sep = "/"))
cat(r2$parsed, "\n")
#> > upload_data(txt = c("{\"Referentie\":\"fa308134-069e-49ce-9847-ccdae380ed6f\",\"OrganisatieCode\":1234,\"ClientGegevens\":{\"Elementen\":[{\"Bdsnummer\":19,\"Waarde\":\"2\"},{\"Bdsnummer\":20,\"Waarde\":\"20181011\"},{\"Bdsnummer\":82,\"Waarde\":\"189\"},{\"Bdsnummer\":91,\"Waarde\":\"1\"},{\"Bdsnummer\":110,\"Waarde\":\"990\"},{\"Bdsnummer\":238,\"Waarde\":\"1670\"},{\"Bdsnummer\":240,\"Waarde\":\"1900\"}],\"Groepen\":[{\"Elementen\":[{\"Bdsnummer\":63,\"Waarde\":\"19950704\"},{\"Bdsnummer\":71,\"Waarde\":\"6030\"},{\"Bdsnummer\":62,\"Waarde\":\"01\"}]},{\"Elementen\":[{\"Bdsnummer\":63,\"Waarde\":\"19901202\"},{\"Bdsnummer\":71,\"Waarde\":\"6030\"},{\"Bdsnummer\":62,\"Waarde\":\"02\"}]}]},\"Contactmomenten\":[{\"Tijdstip\":\"20181111\",\"Elementen\":[{\"Bdsnummer\":235,\"Waarde\":\"380\"},{\"Bdsnummer\":245,\"Waarde\":\"1250\"},{\"Bdsnummer\":252,\"Waarde\":\"270\"}]},{\"Tijdstip\":\"20181211\",\"Elementen\":[{\"Bdsnummer\":235,\"Waarde\":\"435\"},{\"Bdsnummer\":245,\"Waarde\":\"2100\"},{\"Bdsnummer\":252,\"Waarde\":\"305\"}]}]}"))
#> List of length  2 
#> [psn]
#> [xyz]
```

For other end points, see <https://james.groeidiagrammen.nl>.

### `inspect_demodata()`

``` r
library(jamesclient)
data <- inspect_demodata(name = "Anne_S", "smocc", format = "1.0")
data
#> $psn
#>   id   name        dob dobf       dobm src  dnr    sex gad ga smo   bw hgtm
#> 1 -1 Anne S 1989-01-31 <NA> 1961-08-01   0 <NA> female 283 40   0 3300  172
#>   hgtf agem etn
#> 1  183   27  NL
#> 
#> $xyz
#>       age xname yname zname                   zref       x     y      z
#> 1  0.0000   age   hgt hgt_z  nl_1997_hgt_female_nl  0.0000 51.00  0.052
#> 2  0.0986   age   hgt hgt_z  nl_1997_hgt_female_nl  0.0986 54.70  0.145
#> 3  0.1369   age   hgt hgt_z  nl_1997_hgt_female_nl  0.1369 56.00  0.114
#> 4  0.2327   age   hgt hgt_z  nl_1997_hgt_female_nl  0.2327 59.50  0.206
#> 5  0.5010   age   hgt hgt_z  nl_1997_hgt_female_nl  0.5010 68.00  0.661
#> 6  0.7885   age   hgt hgt_z  nl_1997_hgt_female_nl  0.7885 73.00  0.498
#> 7  0.9610   age   hgt hgt_z  nl_1997_hgt_female_nl  0.9610 75.50  0.375
#> 8  1.2485   age   hgt hgt_z  nl_1997_hgt_female_nl  1.2485 80.00  0.434
#> 9  1.5140   age   hgt hgt_z  nl_1997_hgt_female_nl  1.5140 83.50  0.449
#> 10 1.9740   age   hgt hgt_z  nl_1997_hgt_female_nl  1.9740 89.50  0.731
#> 11 0.0000   age   wgt wgt_z  nl_1997_wgt_female_nl  0.0000  3.30 -0.105
#> 12 0.0986   age   wgt wgt_z  nl_1997_wgt_female_nl  0.0986  4.10 -0.280
#> 13 0.1369   age   wgt wgt_z  nl_1997_wgt_female_nl  0.1369  4.52 -0.123
#> 14 0.2327   age   wgt wgt_z  nl_1997_wgt_female_nl  0.2327  5.64  0.350
#> 15 0.5010   age   wgt wgt_z  nl_1997_wgt_female_nl  0.5010  7.95  0.723
#> 16 0.7885   age   wgt wgt_z  nl_1997_wgt_female_nl  0.7885  9.46  0.714
#> 17 0.9610   age   wgt wgt_z  nl_1997_wgt_female_nl  0.9610 10.01  0.552
#> 18 1.2485   age   wgt wgt_z  nl_1997_wgt_female_nl  1.2485 11.35  0.827
#> 19 1.5140   age   wgt wgt_z  nl_1997_wgt_female_nl  1.5140 12.01  0.711
#> 20 1.9740   age   wgt wgt_z  nl_1997_wgt_female_nl  1.9740 13.34  0.747
#> 21 0.0986   age   hdc hdc_z  nl_1997_hdc_female_nl  0.0986 37.60  0.461
#> 22 0.1369   age   hdc hdc_z  nl_1997_hdc_female_nl  0.1369 38.30  0.398
#> 23 0.2327   age   hdc hdc_z  nl_1997_hdc_female_nl  0.2327 40.40  0.655
#> 24 0.5010   age   hdc hdc_z  nl_1997_hdc_female_nl  0.5010 44.40  1.134
#> 25 0.7885   age   hdc hdc_z  nl_1997_hdc_female_nl  0.7885 46.00  0.829
#> 26 0.9610   age   hdc hdc_z  nl_1997_hdc_female_nl  0.9610 47.00  0.929
#> 27 1.2485   age   hdc hdc_z  nl_1997_hdc_female_nl  1.2485 48.00  0.896
#> 28 1.5140   age   hdc hdc_z  nl_1997_hdc_female_nl  1.5140 48.50  0.801
#> 29 1.9740   age   hdc hdc_z  nl_1997_hdc_female_nl  1.9740 50.10  1.354
#> 30 0.0000   age   bmi bmi_z  nl_1997_bmi_female_nl  0.0000 12.69  0.160
#> 31 0.0986   age   bmi bmi_z  nl_1997_bmi_female_nl  0.0986 13.70 -0.476
#> 32 0.1369   age   bmi bmi_z  nl_1997_bmi_female_nl  0.1369 14.41 -0.295
#> 33 0.2327   age   bmi bmi_z  nl_1997_bmi_female_nl  0.2327 15.93  0.214
#> 34 0.5010   age   bmi bmi_z  nl_1997_bmi_female_nl  0.5010 17.19  0.352
#> 35 0.7885   age   bmi bmi_z  nl_1997_bmi_female_nl  0.7885 17.75  0.590
#> 36 0.9610   age   bmi bmi_z  nl_1997_bmi_female_nl  0.9610 17.56  0.514
#> 37 1.2485   age   bmi bmi_z  nl_1997_bmi_female_nl  1.2485 17.73  0.824
#> 38 1.5140   age   bmi bmi_z  nl_1997_bmi_female_nl  1.5140 17.23  0.641
#> 39 1.9740   age   bmi bmi_z  nl_1997_bmi_female_nl  1.9740 16.65  0.436
#> 40 0.0986   age   dsc dsc_z  nl_2014_dsc_female_40  0.0986 14.69  0.190
#> 41 0.1369   age   dsc dsc_z  nl_2014_dsc_female_40  0.1369 16.72 -0.094
#> 42 0.2327   age   dsc dsc_z  nl_2014_dsc_female_40  0.2327 20.82 -0.743
#> 43 0.5010   age   dsc dsc_z  nl_2014_dsc_female_40  0.5010 35.30 -0.002
#> 44 0.7885   age   dsc dsc_z  nl_2014_dsc_female_40  0.7885 41.52 -0.806
#> 45 0.9610   age   dsc dsc_z  nl_2014_dsc_female_40  0.9610 47.59 -0.157
#> 46 1.2485   age   dsc dsc_z  nl_2014_dsc_female_40  1.2485 56.21  0.844
#> 47 1.5140   age   dsc dsc_z  nl_2014_dsc_female_40  1.5140 59.75  0.654
#> 48 1.9740   age   dsc dsc_z  nl_2014_dsc_female_40  1.9740 64.21  0.248
#> 49 0.0000   hgt   wfh wfh_z nl_1997_wfh_female_nla 51.0000  3.30 -0.858
#> 50 0.0986   hgt   wfh wfh_z nl_1997_wfh_female_nla 54.7000  4.10 -0.780
#> 51 0.1369   hgt   wfh wfh_z nl_1997_wfh_female_nla 56.0000  4.52 -0.419
#> 52 0.2327   hgt   wfh wfh_z nl_1997_wfh_female_nla 59.5000  5.64  0.215
#> 53 0.5010   hgt   wfh wfh_z nl_1997_wfh_female_nla 68.0000  7.95  0.326
#> 54 0.7885   hgt   wfh wfh_z nl_1997_wfh_female_nla 73.0000  9.46  0.655
#> 55 0.9610   hgt   wfh wfh_z nl_1997_wfh_female_nla 75.5000 10.01  0.584
#> 56 1.2485   hgt   wfh wfh_z nl_1997_wfh_female_nla 80.0000 11.35  0.851
#> 57 1.5140   hgt   wfh wfh_z nl_1997_wfh_female_nla 83.5000 12.01  0.644
#> 58 1.9740   hgt   wfh wfh_z nl_1997_wfh_female_nla 89.5000 13.34  0.464
```

## Some older functions

Everything can be done with `james_post()` and `james_get()`. The
functions below are not needed anymore, and will be deprecated in the
future.

### `upload_txt()`

Upload BDS data and create a tibble on the server:

``` r
library(jamesclient)
fn <- file.path(path.package("jamesclient"), "testdata", "client3.json")
r1 <- upload_txt(fn)
browseURL(get_url(r1, "return"))
```

### `request_chart()`

Make a combined upload and automatic chartcode choice:

``` r
r2 <- request_chart(fn, chartcode = "PJAHN27")
browseURL(get_url(r2, "svg"))
```

## Removed functions

| Function         | Description              | Alternative    |
|------------------|--------------------------|----------------|
| `request_site()` | Create personalised site | `james_post()` |
| `upload_bds()`   | Upload and parse data    | `james_post()` |
