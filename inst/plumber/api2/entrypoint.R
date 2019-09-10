library(plumber)
pr <- plumber$new()

pr$handle("GET", "/delay", plumbpkg:::delay)

pr
