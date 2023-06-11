
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
fn <- system.file("extdata", "bds_v3.0", "smocc", "Laura_S.json",
                  package = "jamesdemodata", mustWork = TRUE)
host <- "https://james.groeidiagrammen.nl"
r1 <- james_post(host = host, path = "data/upload/json", txt = fn)
r1$parsed
#> $psn
#>   id        dob       dobm src    sex gad ga smo   bw hgtm hgtf agem etn
#> 1 -1 1989-01-21 1961-07-22     female 276 39   0 2950  164  179   27  NL
#> 
#> $xyz
#>      age xname yname zname                   zref      x     y      z
#> 1  0.000   age   hgt hgt_z  nl_1997_hgt_female_nl  0.000 48.00 -1.515
#> 2  0.000   age   wgt wgt_z  nl_1997_wgt_female_nl  0.000  2.95 -1.055
#> 3  0.000   age   bmi bmi_z  nl_1997_bmi_female_nl  0.000 12.80  0.259
#> 4  0.101   age   hgt hgt_z  nl_1997_hgt_female_nl  0.101 53.50 -0.499
#> 5  0.101   age   wgt wgt_z  nl_1997_wgt_female_nl  0.101  4.18 -0.162
#> 6  0.101   age   hdc hdc_z  nl_1997_hdc_female_nl  0.101 37.60  0.418
#> 7  0.101   age   bmi bmi_z  nl_1997_bmi_female_nl  0.101 14.60  0.231
#> 8  0.101   age   dsc dsc_z  ph_2023_dsc_female_40  0.101 14.79 -0.321
#> 9  0.159   age   hgt hgt_z  nl_1997_hgt_female_nl  0.159 56.00 -0.261
#> 10 0.159   age   wgt wgt_z  nl_1997_wgt_female_nl  0.159  5.00  0.401
#> 11 0.159   age   hdc hdc_z  nl_1997_hdc_female_nl  0.159 39.00  0.605
#> 12 0.159   age   bmi bmi_z  nl_1997_bmi_female_nl  0.159 15.94  0.701
#> 13 0.159   age   dsc dsc_z  ph_2023_dsc_female_40  0.159 16.01 -0.569
#> 14 0.235   age   hgt hgt_z  nl_1997_hgt_female_nl  0.235 59.50  0.163
#> 15 0.235   age   wgt wgt_z  nl_1997_wgt_female_nl  0.235  5.90  0.717
#> 16 0.235   age   hdc hdc_z  nl_1997_hdc_female_nl  0.235 40.50  0.696
#> 17 0.235   age   bmi bmi_z  nl_1997_bmi_female_nl  0.235 16.67  0.734
#> 18 0.235   age   dsc dsc_z  ph_2023_dsc_female_40  0.235 19.85 -0.337
#> 19 0.485   age   hgt hgt_z  nl_1997_hgt_female_nl  0.485 65.50 -0.259
#> 20 0.485   age   wgt wgt_z  nl_1997_wgt_female_nl  0.485  8.24  1.173
#> 21 0.485   age   hdc hdc_z  nl_1997_hdc_female_nl  0.485 44.10  1.021
#> 22 0.485   age   bmi bmi_z  nl_1997_bmi_female_nl  0.485 19.21  1.688
#> 23 0.485   age   dsc dsc_z  ph_2023_dsc_female_40  0.485 23.93 -1.897
#> 24 0.753   age   hgt hgt_z  nl_1997_hgt_female_nl  0.753 71.50  0.131
#> 25 0.753   age   wgt wgt_z  nl_1997_wgt_female_nl  0.753  9.65  1.052
#> 26 0.753   age   hdc hdc_z  nl_1997_hdc_female_nl  0.753 46.60  1.418
#> 27 0.753   age   bmi bmi_z  nl_1997_bmi_female_nl  0.753 18.88  1.325
#> 28 0.753   age   dsc dsc_z  ph_2023_dsc_female_40  0.753 40.96 -0.113
#> 29 1.021   age   hgt hgt_z  nl_1997_hgt_female_nl  1.021 75.00 -0.180
#> 30 1.021   age   wgt wgt_z  nl_1997_wgt_female_nl  1.021 10.95  1.164
#> 31 1.021   age   hdc hdc_z  nl_1997_hdc_female_nl  1.021 47.80  1.307
#> 32 1.021   age   bmi bmi_z  nl_1997_bmi_female_nl  1.021 19.47  1.780
#> 33 1.021   age   dsc dsc_z  ph_2023_dsc_female_40  1.021 48.74  0.087
#> 34 1.251   age   hgt hgt_z  nl_1997_hgt_female_nl  1.251 80.00  0.421
#> 35 1.251   age   wgt wgt_z  nl_1997_wgt_female_nl  1.251 11.90  1.247
#> 36 1.251   age   hdc hdc_z  nl_1997_hdc_female_nl  1.251 48.70  1.373
#> 37 1.251   age   bmi bmi_z  nl_1997_bmi_female_nl  1.251 18.59  1.394
#> 38 1.251   age   dsc dsc_z  ph_2023_dsc_female_40  1.251 52.47 -0.207
#> 39 1.539   age   hgt hgt_z  nl_1997_hgt_female_nl  1.539 84.00  0.527
#> 40 1.539   age   wgt wgt_z  nl_1997_wgt_female_nl  1.539 12.80  1.228
#> 41 1.539   age   hdc hdc_z  nl_1997_hdc_female_nl  1.539 49.20  1.246
#> 42 1.539   age   bmi bmi_z  nl_1997_bmi_female_nl  1.539 18.14  1.277
#> 43 1.539   age   dsc dsc_z  ph_2023_dsc_female_40  1.539 54.65 -0.913
#> 44 2.040   age   hgt hgt_z  nl_1997_hgt_female_nl  2.040 90.00  0.670
#> 45 2.040   age   wgt wgt_z  nl_1997_wgt_female_nl  2.040 13.90  0.989
#> 46 2.040   age   hdc hdc_z  nl_1997_hdc_female_nl  2.040 50.00  1.224
#> 47 2.040   age   bmi bmi_z  nl_1997_bmi_female_nl  2.040 17.16  0.825
#> 48 2.040   age   dsc dsc_z  ph_2023_dsc_female_40  2.040 68.34  1.041
#> 49 0.000   hgt   wfh wfh_z nl_1997_wfh_female_nla 48.000  2.95     NA
#> 50 0.101   hgt   wfh wfh_z nl_1997_wfh_female_nla 53.500  4.18  0.215
#> 51 0.159   hgt   wfh wfh_z nl_1997_wfh_female_nla 56.000  5.00  0.764
#> 52 0.235   hgt   wfh wfh_z nl_1997_wfh_female_nla 59.500  5.90  0.744
#> 53 0.485   hgt   wfh wfh_z nl_1997_wfh_female_nla 65.500  8.24  1.728
#> 54 0.753   hgt   wfh wfh_z nl_1997_wfh_female_nla 71.500  9.65  1.342
#> 55 1.021   hgt   wfh wfh_z nl_1997_wfh_female_nla 75.000 10.95  1.726
#> 56 1.251   hgt   wfh wfh_z nl_1997_wfh_female_nla 80.000 11.90  1.379
#> 57 1.539   hgt   wfh wfh_z nl_1997_wfh_female_nla 84.000 12.80  1.242
#> 58 2.040   hgt   wfh wfh_z nl_1997_wfh_female_nla 90.000 13.90  0.820
```

### `james_get()`

Get output from R console (just for checking)

``` r
r2 <- james_get(host = host, path = paste(r1$session, "console", sep = "/"))
cat(r2$parsed, "\n")
#> > upload_data(txt = c("{\"Format\": \"3.0\",\"organisationCode\": 0,\"reference\": \"Laura S\",\"clientDetails\": [{\"bdsNumber\": 19,\"value\": \"2\"},{\"bdsNumber\": 20,\"value\": \"19890121\"},{\"bdsNumber\": 82,\"value\": 276},{\"bdsNumber\": 91,\"value\": \"2\"},{\"bdsNumber\": 110,\"value\": 2950},{\"bdsNumber\": 238,\"value\": 1640},{\"bdsNumber\": 240,\"value\": 1790}],\"clientMeasurements\": [{\"bdsNumber\": 235,\"values\": [{\"date\": \"19890121\",\"value\": 480},{\"date\": \"19890227\",\"value\": 535},{\"date\": \"19890320\",\"value\": 560},{\"date\": \"19890417\",\"value\": 595},{\"date\": \"19890717\",\"value\": 655},{\"date\": \"19891023\",\"value\": 715},{\"date\": \"19900129\",\"value\": 750},{\"date\": \"19900423\",\"value\": 800},{\"date\": \"19900806\",\"value\": 840},{\"date\": \"19910205\",\"value\": 900}]},{\"bdsNumber\": 245,\"values\": [{\"date\": \"19890121\",\"value\": 2950},{\"date\": \"19890227\",\"value\": 4180},{\"date\": \"19890320\",\"value\": 5000},{\"date\": \"19890417\",\"value\": 5900},{\"date\": \"19890717\",\"value\": 8240},{\"date\": \"19891023\",\"value\": 9650},{\"date\": \"19900129\",\"value\": 10950},{\"date\": \"19900423\",\"value\": 11900},{\"date\": \"19900806\",\"value\": 12800},{\"date\": \"19910205\",\"value\": 13900}]},{\"bdsNumber\": 252,\"values\": [{\"date\": \"19890227\",\"value\": 376},{\"date\": \"19890320\",\"value\": 390},{\"date\": \"19890417\",\"value\": 405},{\"date\": \"19890717\",\"value\": 441},{\"date\": \"19891023\",\"value\": 466},{\"date\": \"19900129\",\"value\": 478},{\"date\": \"19900423\",\"value\": 487},{\"date\": \"19900806\",\"value\": 492},{\"date\": \"19910205\",\"value\": 500}]},{\"bdsNumber\": 879,\"values\": [{\"date\": \"19890227\",\"value\": \"1\"}]},{\"bdsNumber\": 881,\"values\": [{\"date\": \"19890227\",\"value\": \"2\"},{\"date\": \"19890320\",\"value\": \"1\"}]},{\"bdsNumber\": 883,\"values\": [{\"date\": \"19890227\",\"value\": \"2\"},{\"date\": \"19890320\",\"value\": \"1\"}]},{\"bdsNumber\": 884,\"values\": [{\"date\": \"19890227\",\"value\": \"1\"},{\"date\": \"19890417\",\"value\": \"1\"}]},{\"bdsNumber\": 885,\"values\": [{\"date\": \"19890227\",\"value\": \"1\"},{\"date\": \"19890417\",\"value\": \"1\"}]},{\"bdsNumber\": 886,\"values\": [{\"date\": \"19890320\",\"value\": \"2\"},{\"date\": \"19890417\",\"value\": \"2\"},{\"date\": \"19890717\",\"value\": \"3\"}]},{\"bdsNumber\": 887,\"values\": [{\"date\": \"19890417\",\"value\": \"2\"},{\"date\": \"19890717\",\"value\": \"1\"}]},{\"bdsNumber\": 888,\"values\": [{\"date\": \"19890417\",\"value\": \"2\"},{\"date\": \"19890717\",\"value\": \"1\"}]},{\"bdsNumber\": 889,\"values\": [{\"date\": \"19890417\",\"value\": \"2\"},{\"date\": \"19890717\",\"value\": \"1\"}]},{\"bdsNumber\": 890,\"values\": [{\"date\": \"19890717\",\"value\": \"2\"},{\"date\": \"19891023\",\"value\": \"1\"}]},{\"bdsNumber\": 891,\"values\": [{\"date\": \"19890717\",\"value\": \"2\"},{\"date\": \"19891023\",\"value\": \"1\"}]},{\"bdsNumber\": 892,\"values\": [{\"date\": \"19890717\",\"value\": \"2\"},{\"date\": \"19891023\",\"value\": \"3\"}]},{\"bdsNumber\": 893,\"values\": [{\"date\": \"19890717\",\"value\": \"2\"},{\"date\": \"19891023\",\"value\": \"3\"}]},{\"bdsNumber\": 894,\"values\": [{\"date\": \"19891023\",\"value\": \"1\"},{\"date\": \"19900129\",\"value\": \"1\"}]},{\"bdsNumber\": 896,\"values\": [{\"date\": \"19891023\",\"value\": \"1\"},{\"date\": \"19900129\",\"value\": \"1\"}]},{\"bdsNumber\": 897,\"values\": [{\"date\": \"19900129\",\"value\": \"1\"},{\"date\": \"19900423\",\"value\": \"1\"}]},{\"bdsNumber\": 898,\"values\": [{\"date\": \"19900129\",\"value\": \"1\"},{\"date\": \"19900423\",\"value\": \"1\"}]},{\"bdsNumber\": 900,\"values\": [{\"date\": \"19900129\",\"value\": \"3\"},{\"date\": \"19900423\",\"value\": \"3\"}]},{\"bdsNumber\": 902,\"values\": [{\"date\": \"19900423\",\"value\": \"2\"},{\"date\": \"19900806\",\"value\": \"1\"},{\"date\": \"19910205\",\"value\": \"1\"}]},{\"bdsNumber\": 903,\"values\": [{\"date\": \"19900423\",\"value\": \"2\"},{\"date\": \"19900806\",\"value\": \"2\"},{\"date\": \"19910205\",\"value\": \"1\"}]},{\"bdsNumber\": 905,\"values\": [{\"date\": \"19900423\",\"value\": \"1\"},{\"date\": \"19900806\",\"value\": \"1\"}]},{\"bdsNumber\": 906,\"values\": [{\"date\": \"19900806\",\"value\": \"2\"},{\"date\": \"19910205\",\"value\": \"1\"}]},{\"bdsNumber\": 907,\"values\": [{\"date\": \"19900806\",\"value\": \"2\"},{\"date\": \"19910205\",\"value\": \"1\"}]},{\"bdsNumber\": 909,\"values\": [{\"date\": \"19900806\",\"value\": \"3\"},{\"date\": \"19910205\",\"value\": \"3\"}]},{\"bdsNumber\": 910,\"values\": [{\"date\": \"19910205\",\"value\": \"1\"}]},{\"bdsNumber\": 912,\"values\": [{\"date\": \"19910205\",\"value\": \"1\"}]},{\"bdsNumber\": 921,\"values\": [{\"date\": \"19910205\",\"value\": \"3\"}]},{\"bdsNumber\": 927,\"values\": [{\"date\": \"19890227\",\"value\": \"1\"}]},{\"bdsNumber\": 928,\"values\": [{\"date\": \"19890227\",\"value\": \"2\"}]},{\"bdsNumber\": 930,\"values\": [{\"date\": \"19890320\",\"value\": \"3\"},{\"date\": \"19890417\",\"value\": \"3\"}]},{\"bdsNumber\": 932,\"values\": [{\"date\": \"19890717\",\"value\": \"2\"},{\"date\": \"19891023\",\"value\": \"3\"}]},{\"bdsNumber\": 933,\"values\": [{\"date\": \"19891023\",\"value\": \"3\"},{\"date\": \"19900129\",\"value\": \"3\"}]},{\"bdsNumber\": 935,\"values\": [{\"date\": \"19891023\",\"value\": \"2\"},{\"date\": \"19900129\",\"value\": \"3\"}]},{\"bdsNumber\": 936,\"values\": [{\"date\": \"19900129\",\"value\": \"2\"},{\"date\": \"19900423\",\"value\": \"3\"}]},{\"bdsNumber\": 937,\"values\": [{\"date\": \"19900129\",\"value\": \"2\"},{\"date\": \"19900423\",\"value\": \"3\"}]},{\"bdsNumber\": 938,\"values\": [{\"date\": \"19900423\",\"value\": \"3\"},{\"date\": \"19900806\",\"value\": \"3\"}]},{\"bdsNumber\": 940,\"values\": [{\"date\": \"19900806\",\"value\": \"3\"},{\"date\": \"19910205\",\"value\": \"3\"}]},{\"bdsNumber\": 943,\"values\": [{\"date\": \"19910205\",\"value\": \"3\"}]},{\"bdsNumber\": 945,\"values\": [{\"date\": \"19910205\",\"value\": \"1\"}]},{\"bdsNumber\": 955,\"values\": [{\"date\": \"19890227\",\"value\": \"1\"}]},{\"bdsNumber\": 956,\"values\": [{\"date\": \"19890227\",\"value\": \"1\"}]},{\"bdsNumber\": 958,\"values\": [{\"date\": \"19890227\",\"value\": \"1\"}]},{\"bdsNumber\": 959,\"values\": [{\"date\": \"19890227\",\"value\": \"1\"}]},{\"bdsNumber\": 961,\"values\": [{\"date\": \"19890227\",\"value\": \"1\"},{\"date\": \"19890417\",\"value\": \"1\"}]},{\"bdsNumber\": 962,\"values\": [{\"date\": \"19890417\",\"value\": \"2\"},{\"date\": \"19890717\",\"value\": \"1\"}]},{\"bdsNumber\": 964,\"values\": [{\"date\": \"19890227\",\"value\": \"1\"}]},{\"bdsNumber\": 966,\"values\": [{\"date\": \"19890227\",\"value\": \"1\"},{\"date\": \"19890417\",\"value\": \"1\"}]},{\"bdsNumber\": 968,\"values\": [{\"date\": \"19890417\",\"value\": \"1\"},{\"date\": \"19890717\",\"value\": \"1\"}]},{\"bdsNumber\": 969,\"values\": [{\"date\": \"19890417\",\"value\": \"1\"},{\"date\": \"19890717\",\"value\": \"1\"}]},{\"bdsNumber\": 970,\"values\": [{\"date\": \"19890417\",\"value\": \"1\"},{\"date\": \"19890717\",\"value\": \"1\"}]},{\"bdsNumber\": 973,\"values\": [{\"date\": \"19890717\",\"value\": \"2\"},{\"date\": \"19891023\",\"value\": \"3\"}]},{\"bdsNumber\": 975,\"values\": [{\"date\": \"19890717\",\"value\": \"1\"},{\"date\": \"19891023\",\"value\": \"1\"}]},{\"bdsNumber\": 976,\"values\": [{\"date\": \"19890717\",\"value\": \"2\"},{\"date\": \"19891023\",\"value\": \"1\"}]},{\"bdsNumber\": 978,\"values\": [{\"date\": \"19891023\",\"value\": \"1\"},{\"date\": \"19900129\",\"value\": \"1\"}]},{\"bdsNumber\": 980,\"values\": [{\"date\": \"19891023\",\"value\": \"3\"},{\"date\": \"19900129\",\"value\": \"3\"}]},{\"bdsNumber\": 982,\"values\": [{\"date\": \"19900129\",\"value\": \"1\"},{\"date\": \"19900423\",\"value\": \"1\"}]},{\"bdsNumber\": 984,\"values\": [{\"date\": \"19900129\",\"value\": \"1\"},{\"date\": \"19900423\",\"value\": \"1\"}]},{\"bdsNumber\": 986,\"values\": [{\"date\": \"19900423\",\"value\": \"1\"},{\"date\": \"19900806\",\"value\": \"1\"}]},{\"bdsNumber\": 989,\"values\": [{\"date\": \"19900423\",\"value\": \"2\"},{\"date\": \"19900806\",\"value\": \"2\"},{\"date\": \"19910205\",\"value\": \"1\"}]},{\"bdsNumber\": 991,\"values\": [{\"date\": \"19900806\",\"value\": \"1\"},{\"date\": \"19910205\",\"value\": \"1\"}]},{\"bdsNumber\": 993,\"values\": [{\"date\": \"19910205\",\"value\": \"1\"}]},{\"bdsNumber\": 1278,\"values\": [{\"date\": \"19891023\",\"value\": \"3\"},{\"date\": \"19900129\",\"value\": \"3\"}]}],\"nestedDetails\": [{\"nestingBdsNumber\": 62,\"nestingCode\": \"02\",\"clientDetails\": [{\"bdsNumber\": 63,\"value\": \"19610722\"}],\"clientMeasurements\": []}]}"))
#> List of length  2 
#> [psn]
#> [xyz]
```

For other end points, see <https://james.groeidiagrammen.nl>.

### `inspect_demodata()`

``` r
library(jamesclient)
data <- inspect_demodata(name = "Anne_S", "smocc")
#> BDS  82 (Zwangerschapsduur): Supplied: 283, Supplied type: character
#> 
#> BDS 110 (Geboortegewicht): Supplied: 3300, Supplied type: character
#> 
#> BDS 238 (Lengte biologische moeder): Supplied: 1720, Supplied type: character
#> 
#> BDS 240 (Lengte biologische vader): Supplied: 1830, Supplied type: character
#> 
#> BDS 986 (68. Loopt los): Supplied: one or more supplied values, Supplied type: list
#> 
#> BDS 986 (68. Loopt goed los): Supplied: one or more supplied values, Supplied type: list
#> 
#> BDS 986 (68. Loopt soepel): Supplied: one or more supplied values, Supplied type: list
data
#> $psn
#>   id name        dob dobf       dobm src  dnr    sex gad ga smo   bw hgtm hgtf
#> 1 -1 <NA> 1989-01-31 <NA> 1961-08-01   0 <NA> female 283 40   0 3300  172  183
#>   agem etn
#> 1   27  NL
#> 
#> $xyz
#>       age xname yname zname                   zref       x     y      z
#> 1  0.0000   age   hgt hgt_z  nl_1997_hgt_female_nl  0.0000 51.00  0.052
#> 2  0.0000   age   wgt wgt_z  nl_1997_wgt_female_nl  0.0000  3.30 -0.105
#> 3  0.0000   age   bmi bmi_z  nl_1997_bmi_female_nl  0.0000 12.69  0.160
#> 4  0.0986   age   hgt hgt_z  nl_1997_hgt_female_nl  0.0986 54.70  0.145
#> 5  0.0986   age   wgt wgt_z  nl_1997_wgt_female_nl  0.0986  4.10 -0.280
#> 6  0.0986   age   hdc hdc_z  nl_1997_hdc_female_nl  0.0986 37.60  0.461
#> 7  0.0986   age   bmi bmi_z  nl_1997_bmi_female_nl  0.0986 13.70 -0.476
#> 8  0.0986   age   dsc dsc_z  ph_2023_dsc_female_40  0.0986 14.85 -0.276
#> 9  0.1369   age   hgt hgt_z  nl_1997_hgt_female_nl  0.1369 56.00  0.114
#> 10 0.1369   age   wgt wgt_z  nl_1997_wgt_female_nl  0.1369  4.52 -0.123
#> 11 0.1369   age   hdc hdc_z  nl_1997_hdc_female_nl  0.1369 38.30  0.398
#> 12 0.1369   age   bmi bmi_z  nl_1997_bmi_female_nl  0.1369 14.41 -0.295
#> 13 0.1369   age   dsc dsc_z  ph_2023_dsc_female_40  0.1369 16.04 -0.325
#> 14 0.2327   age   hgt hgt_z  nl_1997_hgt_female_nl  0.2327 59.50  0.206
#> 15 0.2327   age   wgt wgt_z  nl_1997_wgt_female_nl  0.2327  5.64  0.350
#> 16 0.2327   age   hdc hdc_z  nl_1997_hdc_female_nl  0.2327 40.40  0.655
#> 17 0.2327   age   bmi bmi_z  nl_1997_bmi_female_nl  0.2327 15.93  0.214
#> 18 0.2327   age   dsc dsc_z  ph_2023_dsc_female_40  0.2327 18.18 -0.778
#> 19 0.5010   age   hgt hgt_z  nl_1997_hgt_female_nl  0.5010 68.00  0.661
#> 20 0.5010   age   wgt wgt_z  nl_1997_wgt_female_nl  0.5010  7.95  0.723
#> 21 0.5010   age   hdc hdc_z  nl_1997_hdc_female_nl  0.5010 44.40  1.134
#> 22 0.5010   age   bmi bmi_z  nl_1997_bmi_female_nl  0.5010 17.19  0.352
#> 23 0.5010   age   dsc dsc_z  ph_2023_dsc_female_40  0.5010 28.06 -1.132
#> 24 0.7885   age   hgt hgt_z  nl_1997_hgt_female_nl  0.7885 73.00  0.498
#> 25 0.7885   age   wgt wgt_z  nl_1997_wgt_female_nl  0.7885  9.46  0.714
#> 26 0.7885   age   hdc hdc_z  nl_1997_hdc_female_nl  0.7885 46.00  0.829
#> 27 0.7885   age   bmi bmi_z  nl_1997_bmi_female_nl  0.7885 17.75  0.590
#> 28 0.7885   age   dsc dsc_z  ph_2023_dsc_female_40  0.7885 36.28 -1.543
#> 29 0.9610   age   hgt hgt_z  nl_1997_hgt_female_nl  0.9610 75.50  0.375
#> 30 0.9610   age   wgt wgt_z  nl_1997_wgt_female_nl  0.9610 10.01  0.552
#> 31 0.9610   age   hdc hdc_z  nl_1997_hdc_female_nl  0.9610 47.00  0.929
#> 32 0.9610   age   bmi bmi_z  nl_1997_bmi_female_nl  0.9610 17.56  0.514
#> 33 0.9610   age   dsc dsc_z  ph_2023_dsc_female_40  0.9610 45.89 -0.300
#> 34 1.2485   age   hgt hgt_z  nl_1997_hgt_female_nl  1.2485 80.00  0.434
#> 35 1.2485   age   wgt wgt_z  nl_1997_wgt_female_nl  1.2485 11.35  0.827
#> 36 1.2485   age   hdc hdc_z  nl_1997_hdc_female_nl  1.2485 48.00  0.896
#> 37 1.2485   age   bmi bmi_z  nl_1997_bmi_female_nl  1.2485 17.73  0.824
#> 38 1.2485   age   dsc dsc_z  ph_2023_dsc_female_40  1.2485 54.48  0.374
#> 39 1.5140   age   hgt hgt_z  nl_1997_hgt_female_nl  1.5140 83.50  0.449
#> 40 1.5140   age   wgt wgt_z  nl_1997_wgt_female_nl  1.5140 12.01  0.711
#> 41 1.5140   age   hdc hdc_z  nl_1997_hdc_female_nl  1.5140 48.50  0.801
#> 42 1.5140   age   bmi bmi_z  nl_1997_bmi_female_nl  1.5140 17.23  0.641
#> 43 1.5140   age   dsc dsc_z  ph_2023_dsc_female_40  1.5140 59.74  0.598
#> 44 1.9740   age   hgt hgt_z  nl_1997_hgt_female_nl  1.9740 89.50  0.731
#> 45 1.9740   age   wgt wgt_z  nl_1997_wgt_female_nl  1.9740 13.34  0.747
#> 46 1.9740   age   hdc hdc_z  nl_1997_hdc_female_nl  1.9740 50.10  1.354
#> 47 1.9740   age   bmi bmi_z  nl_1997_bmi_female_nl  1.9740 16.65  0.436
#> 48 1.9740   age   dsc dsc_z  ph_2023_dsc_female_40  1.9740 63.81 -0.051
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
