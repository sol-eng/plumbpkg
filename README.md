# plumbpkg

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/sol-eng/plumbpkg.svg?branch=master)](https://travis-ci.org/sol-eng/plumbpkg)
<!-- badges: end -->

This is a simple package illustrating how to incorporate
[Plumber](https://www.rplumber.io) APIs into an R package. There are two main
motivations behind this example:

1. Demonstrate how to build Plumber APIs into a package
2. Demonstrate how to test Plumber APIs using [testthat](https://testthat.r-lib.org)

## Installation

```r
# install.packages("remotes")
remotes::install_github("sol-eng/plumbpkg")
```

## Architecture
The design of this package is heavily influenced by [this
discussion](https://community.rstudio.com/t/plumber-api-and-package-structure/18099)
on RStudio Community.

```
── DESCRIPTION
├── LICENSE
├── LICENSE.md
├── NAMESPACE
├── R
│   ├── api1.R
│   └── api2.R
├── README.md
├── inst
│   └── plumber
│       ├── api1
│       │   └── plumber.R
│       └── api2
│           ├── entrypoint.R
│           └── plumber.R
├── man
├── plumbpkg.Rproj
└── tests
    ├── testthat
    │   ├── test-api1.R
    │   ├── test-api2.R
    │   └── test-plumber.R
    └── testthat.R
```

The `R/` directory contains all of the R functions used in the Plumber APIs.
This enables the functions to be tested using files in the `tests/` directory.
The Plumber APIs are defined in files in `inst/plumber/` and are also tested 
using testthat and [httr](https://httr.r-lib.org).
