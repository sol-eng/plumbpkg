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


## Deploy
This repository deploys both APIs to [RStudio
Connect](https://www.rstudio.com/products/connect/) using
[Travis](https://travis-ci.org/). The deployment is managed by
[`scripts/deploy-rsc.sh`](scripts/deploy-rsc.sh) and uses the RStudio Connect
API. Because this repository uses Travis, the APIs will only be deployed
**after** tests have successfully completed.

There are certainly other ways this content could be deployed, either using
other CI/CD solutions or using [RStudio Connect's ability to publish content
from a git
repository](https://docs.rstudio.com/connect/1.7.6/user/git-backed.html).
