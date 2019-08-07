# save installed.cabinets as json files for testing
library(jamestest)
path <- path.expand("~/Package/jamesclient/jamestest")

cabs <- names(installed.cabinets)[2:5]

# installed.cabinets

for (cab in cabs) {
  dir <- file.path(path, "inst/extdata", cab)
  cabinet <- installed.cabinets[[cab]]
  for (i in 1:length(cabinet)) {
    ind <- cabinet[[i]]
    js <- convert_individual_bds(ind = ind)
    fn <- file.path(dir, paste0(gsub(" ", "_", slot(ind, "name")), ".json"))
    writeLines(text = js, con = fn)
  }
}
