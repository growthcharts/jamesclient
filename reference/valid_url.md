# Check for URL existence

Taken from
<https://stackoverflow.com/questions/52911812/check-if-url-exists-in-r>.

## Usage

``` r
valid_url(url_in, t = 2)
```

## Arguments

- url_in:

  String of URL to test

- t:

  Time out

## Examples

``` r
urls <- c(
  "http://www.amazon.com", "http://this.isafakelink.biz",
  "https://stackoverflow.com", "http://localhost:8080")
sapply(urls, valid_url)
#>       http://www.amazon.com http://this.isafakelink.biz 
#>                        TRUE                       FALSE 
#>   https://stackoverflow.com       http://localhost:8080 
#>                        TRUE                       FALSE 
```
