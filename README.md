# nanotools

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/nanotools)](https://CRAN.R-project.org/package=nanotools)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/jeanmathieupotvin/nanotools/workflows/R-CMD-check/badge.svg)](https://github.com/jeanmathieupotvin/nanotools/actions)
[![codecov](https://codecov.io/gh/jeanmathieupotvin/nanotools/branch/main/graph/badge.svg?token=4W6SAS5EMH)](https://app.codecov.io/gh/jeanmathieupotvin/nanotools)
<!-- badges: end -->

A toolbox of simpler alternatives and wrapper functions to `R` features. The
intent is threefold:

1. simplify features whenever possible (keep it simple),
2. minimize reliance on dependencies (keep it small), and
3. provide pure `R` alternatives that are as fast and efficient as possible (keep it fast).


## Context

`R` is a very mature language. Its official repository
[The Comprehensive R Archive Network](https://cran.r-project.org),
contains more than 16 000 packages. Major communities have emerged over the
years and organized themselves around recognized ecosystems. Each of these
can be considered as meta-languages derived from `R`. Some of them greatly
differ from base / core `R`. Others are so complex (dozens of dependencies)
that they have a non-negligible *entry cost*.

While these advanced ecosystems are *powerful*, they can introduce a
non-negligible overhead. It takes time to learn these micro-languages.
It takes time to maintain them in production environments. Sometimes,
there is \emph{no} time. Sometimes, you just need to *get the job done*.
And fast.

Package `nanotools` seeks to be a lighter alternative that is easy
to learn, use, and manage.


## Installation

This package is in a pre-alpha version and should not be used until further
notice. If you insist on using it, you can install the development version
from [GitHub](https://github.com/).

``` r
# install.packages("devtools")
devtools::install_github("jeanmathieupotvin/nanotools")
```


## Issues, bugs, and feedback

Submit them [here](https://github.com/jeanmathieupotvin/nanotools/issues/new),
via Github.
