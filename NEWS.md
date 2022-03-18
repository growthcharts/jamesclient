# jamesclient 0.28.0

- Simplifies `james_get()`
- Updates README
- Removes dependency on `bdsreader` package

# jamesclient 0.27.0

- Adds `mod` parameters to handle "hosts" with a module path. The contents of `mod` is prepended to the `path`.

# jamesclient 0.26.1

- Prevents redirects for messages and warnings in `james_get()` and `james_post()`

# jamesclient 0.26.0

### Breaking changes

- Redefines the response values of `james_get()` and `james_post` to conform to `httr` response object
- Redefines `james_post()` so that it return a response in case of a request error

### Other changes

- `get_url()` now works without the location header
- Adds new tests for `james_post()`
- Makes now only one reference to `x-ocpu-session` header

# jamesclient 0.25.0

- Sets `https://james.groeidiagrammen.nl` as default host in `upload_txt()`

# jamesclient 0.24.0

- Adds support for SVG file in `james_post()`

# jamesclient 0.23.0

- Add `read_json_js()` and `read_json_jo()` to read JSON data
- Solve bug in `james_get()` that gave wrong URL modifications
- Solve bug in `james_post()` that gave "cannot process 'txt'" for `text = NULL`

# jamesclient 0.22.1

- Simplify `james_post()` by string read
- Change `url.exists()` into `is.url()`

# jamesclient 0.22.0

- Adds `dots` argument to `james_post()` and `james_get()`

# jamesclient 0.21.0

- Adds `host` argument to `james_post()` and `james_get()`

# jamesclient 0.20.0

- Does not append `"json"` anymore to path in `james_api()`

# jamesclient 0.19.1

- Use `multipart` and `file_upload()` POST request when `txt` is a local file

# jamesclient 0.19.0

- Adds generic `james_get()` and `james_post()` functions

# jamesclient 0.18.1

- Adds options `json` and `rda` to `get_url()`
- Makes `upload_txt()` work with all JSON vector input

# jamesclient 0.18.0

- Rewrites `upload_txt()` 
- Rewrites `inspect_upload()`, and renames it to `inspect_demodata()`
- Updates test file to work with multiple hosts
- Updates `request_chart()` and provides extensive and working examples

# jamesclient 0.17.0

- Generalises `inspect_upload()` and `upload_txt()` to work with the `format` argument to accept multi-format child data

# jamesclient 0.16.0

- Add function `inspect_upload()` that uploads child data and downloads the R object as parsed by JAMES

# jamesclient 0.15.0

- Adds tweaks to DESCRIPTION

# jamesclient 0.14.0

- Adds GitHub action `R-CMD-check` and `pkgdown`

# jamesclient 0.13.0

- Transfers to `growthcharts` GH organisation
- Merges the `bdsreader` branch that replaces `minihealth` by `bdsreader`

# jamesclient 0.12.0

- Repairs an error in `upload_txt()` that prevented proper file upload
- Replaces `jamestest` by `jamesdemodata` package

# jamesclient 0.11.0

- Moves `upload_txt()` from `james` to `jamesclient` package
- Removes `upload_bds()` and `request_site()`
- Styles files

# jamesclient 0.7.0

- Makes upload_bds() aware of server errors, warnings and messages

# jamesclient 0.6.0

- Adds test infrastructure
- Adds message get_url()

# jamesclient 0.5.0

- More robust version of `upload_bds`

# jamesclient 0.2.0

- Rename package to `jamesclient` (no dot)

# james.client 0.1.0

* Added a `NEWS.md` file to track changes to the package.
