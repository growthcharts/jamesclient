# Changelog

## jamesclient 0.36.1

- Use system variable `JAMES_BEARER_TOKEN` to add authentication to
  [`james_get()`](https://growthcharts.org/jamesclient/reference/james_get.md)
  and
  [`james_post()`](https://growthcharts.org/jamesclient/reference/james_post.md)

## jamesclient 0.36.0

- Adds support for `config = httr::config()` in
  [`httr::GET`](https://httr.r-lib.org/reference/GET.html) and
  [`httr::POST`](https://httr.r-lib.org/reference/POST.html) requests

## jamesclient 0.35.0

- Improves robustness of
  [`james_post()`](https://growthcharts.org/jamesclient/reference/james_post.md)
  and
  [`upload_txt()`](https://growthcharts.org/jamesclient/reference/upload_txt.md)

## jamesclient 0.34.0

- Sets localhost port to 8080
- Updates GH workflows

## jamesclient 0.33.0

- Loads the example data from `jamesdemodata` instead of `bdsreader`

## jamesclient 0.32.1

- Use example URL from bdsreader instead of jamesdemodata (not in
  docker)

## jamesclient 0.32.0

- Make all example code work
- Replaces [`readLines()`](https://rdrr.io/r/base/readLines.html) by
  more robust
  [`read_json_js()`](https://growthcharts.org/jamesclient/reference/read_json_js.md)
- Updates examples to bds V3.0 data schema
- Update README
- Removes several `\dontrun` to elaborate code checking

## jamesclient 0.31.1

- Patch a problem with
  [`readLines()`](https://rdrr.io/r/base/readLines.html) in the tests

## jamesclient 0.31.0

- Make
  [`upload_txt()`](https://growthcharts.org/jamesclient/reference/upload_txt.md)
  work for JSON files in pretty format

## jamesclient 0.30.0

- Removes the `mod` parameter
- Support `host` specification as `"http://myhost.nl/module"`

## jamesclient 0.29.0

- Adds
  [`valid_url()`](https://growthcharts.org/jamesclient/reference/valid_url.md)
  to test for existence of URL
- Executes examples and tests conditional on a valid URL
- Adds AGPL-3 licence

## jamesclient 0.28.2

- Adds `_pkgdown.yaml` to automate site building

## jamesclient 0.28.1

- Disables testing (services may be offline)
- Refreshes github actions scripts

## jamesclient 0.28.0

- Simplifies
  [`james_get()`](https://growthcharts.org/jamesclient/reference/james_get.md)
- Updates README
- Removes dependency on `bdsreader` package

## jamesclient 0.27.0

- Adds `mod` parameters to handle “hosts” with a module path. The
  contents of `mod` is prepended to the `path`.

## jamesclient 0.26.1

- Prevents redirects for messages and warnings in
  [`james_get()`](https://growthcharts.org/jamesclient/reference/james_get.md)
  and
  [`james_post()`](https://growthcharts.org/jamesclient/reference/james_post.md)

## jamesclient 0.26.0

#### Breaking changes

- Redefines the response values of
  [`james_get()`](https://growthcharts.org/jamesclient/reference/james_get.md)
  and `james_post` to conform to `httr` response object
- Redefines
  [`james_post()`](https://growthcharts.org/jamesclient/reference/james_post.md)
  so that it return a response in case of a request error

#### Other changes

- [`get_url()`](https://growthcharts.org/jamesclient/reference/get_url.md)
  now works without the location header
- Adds new tests for
  [`james_post()`](https://growthcharts.org/jamesclient/reference/james_post.md)
- Makes now only one reference to `x-ocpu-session` header

## jamesclient 0.25.0

- Sets `https://james.groeidiagrammen.nl` as default host in
  [`upload_txt()`](https://growthcharts.org/jamesclient/reference/upload_txt.md)

## jamesclient 0.24.0

- Adds support for SVG file in
  [`james_post()`](https://growthcharts.org/jamesclient/reference/james_post.md)

## jamesclient 0.23.0

- Add
  [`read_json_js()`](https://growthcharts.org/jamesclient/reference/read_json_js.md)
  and
  [`read_json_jo()`](https://growthcharts.org/jamesclient/reference/read_json_js.md)
  to read JSON data
- Solve bug in
  [`james_get()`](https://growthcharts.org/jamesclient/reference/james_get.md)
  that gave wrong URL modifications
- Solve bug in
  [`james_post()`](https://growthcharts.org/jamesclient/reference/james_post.md)
  that gave “cannot process ‘txt’” for `text = NULL`

## jamesclient 0.22.1

- Simplify
  [`james_post()`](https://growthcharts.org/jamesclient/reference/james_post.md)
  by string read
- Change `url.exists()` into `is.url()`

## jamesclient 0.22.0

- Adds `dots` argument to
  [`james_post()`](https://growthcharts.org/jamesclient/reference/james_post.md)
  and
  [`james_get()`](https://growthcharts.org/jamesclient/reference/james_get.md)

## jamesclient 0.21.0

- Adds `host` argument to
  [`james_post()`](https://growthcharts.org/jamesclient/reference/james_post.md)
  and
  [`james_get()`](https://growthcharts.org/jamesclient/reference/james_get.md)

## jamesclient 0.20.0

- Does not append `"json"` anymore to path in `james_api()`

## jamesclient 0.19.1

- Use `multipart` and `file_upload()` POST request when `txt` is a local
  file

## jamesclient 0.19.0

- Adds generic
  [`james_get()`](https://growthcharts.org/jamesclient/reference/james_get.md)
  and
  [`james_post()`](https://growthcharts.org/jamesclient/reference/james_post.md)
  functions

## jamesclient 0.18.1

- Adds options `json` and `rda` to
  [`get_url()`](https://growthcharts.org/jamesclient/reference/get_url.md)
- Makes
  [`upload_txt()`](https://growthcharts.org/jamesclient/reference/upload_txt.md)
  work with all JSON vector input

## jamesclient 0.18.0

- Rewrites
  [`upload_txt()`](https://growthcharts.org/jamesclient/reference/upload_txt.md)
- Rewrites `inspect_upload()`, and renames it to
  [`inspect_demodata()`](https://growthcharts.org/jamesclient/reference/inspect_demodata.md)
- Updates test file to work with multiple hosts
- Updates
  [`request_chart()`](https://growthcharts.org/jamesclient/reference/request_chart.md)
  and provides extensive and working examples

## jamesclient 0.17.0

- Generalises `inspect_upload()` and
  [`upload_txt()`](https://growthcharts.org/jamesclient/reference/upload_txt.md)
  to work with the `format` argument to accept multi-format child data

## jamesclient 0.16.0

- Add function `inspect_upload()` that uploads child data and downloads
  the R object as parsed by JAMES

## jamesclient 0.15.0

- Adds tweaks to DESCRIPTION

## jamesclient 0.14.0

- Adds GitHub action `R-CMD-check` and `pkgdown`

## jamesclient 0.13.0

- Transfers to `growthcharts` GH organisation
- Merges the `bdsreader` branch that replaces `minihealth` by
  `bdsreader`

## jamesclient 0.12.0

- Repairs an error in
  [`upload_txt()`](https://growthcharts.org/jamesclient/reference/upload_txt.md)
  that prevented proper file upload
- Replaces `jamestest` by `jamesdemodata` package

## jamesclient 0.11.0

- Moves
  [`upload_txt()`](https://growthcharts.org/jamesclient/reference/upload_txt.md)
  from `james` to `jamesclient` package
- Removes `upload_bds()` and `request_site()`
- Styles files

## jamesclient 0.7.0

- Makes upload_bds() aware of server errors, warnings and messages

## jamesclient 0.6.0

- Adds test infrastructure
- Adds message get_url()

## jamesclient 0.5.0

- More robust version of `upload_bds`

## jamesclient 0.2.0

- Rename package to `jamesclient` (no dot)
