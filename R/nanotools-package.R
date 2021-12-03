#' nanotools: Simpler Alternatives to R Features
#'
#' @description A toolbox of simpler alternatives and wrapper functions to \R
#'   features. The intent is threefold:
#'
#'   1. simplify features whenever possible (keep it simple),
#'   2. minimize reliance on dependencies (keep it small), and
#'   3. provide pure \R alternatives that are as fast and efficient as
#'   possible (keep it fast).
#'
#' @section Context: \R is a very mature language. Its official repository
#' ([*The Comprehensive R Archive Network*](https://cran.r-project.org/)),
#' contains more than 16 000 packages. Major communities have emerged over the
#' years and organized themselves around recognized ecosystems. Each of these
#' can be considered as meta-languages derived from \R. Some of them greatly
#' differ from \pkg{base} \R. Others are so complex (dozens of dependencies)
#' that they have a non-negligible *entry cost*.
#'
#' While these advanced ecosystems are *powerful*, they can introduce a
#' non-negligible overhead. It takes time to learn these micro-languages.
#' It takes time to maintain them in production environments. Sometimes,
#' there is *no* time. Sometimes, you just need to *get the job done*.
#' And fast.
#'
#' Package \pkg{nanotools} seeks to be a lighter alternative that is easy
#' to learn, use, and manage.
#'
#' @docType package
#' @name nanotools-package
"_PACKAGE"
