library(gateway)
library(groeidiagrammen)

fn <- file.path(path.package("gateway"), "testdata", "client3.json")
p <- bds_to_individual(fn)

