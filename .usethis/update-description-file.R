#' Package's description
#'
#' Create and update the usual top-level DESCRIPTION file.


# Initialize file with core fields ---------------------------------------------


usethis::use_description(check_name = TRUE, roxygen = TRUE, fields = list(
    Package          = "nanocli",
    Title            = "Create command-line interfaces easily",
    License          = "MIT + file LICENSE",
    Language         = "en",
    Encoding         = "UTF-8",
    ByteCompile      = "true",
    NeedsCompilation = "no",
    Roxygen          = "list(markdown = TRUE, r6 = TRUE)",
    URL              = "https://github.com/jeanmathieupotvin/nanocli",
    BugReports       = "https://github.com/jeanmathieupotvin/nanocli/issues/new", # nolint
    `Authors@R`      = 'utils::person(
        given   = "Jean-Mathieu",
        family  = "Potvin",
        email   = "jm@potvin.xyz",
        role    = c("aut", "cre"),
        comment = c(ORCID = "0000-0002-8237-422X"))',
    Description = "
        Convey messages with style and minimal code. Throw, register, and
        retrieve errors more easily. Interpolate and format strings with a
        clean syntax. Avoid dependency hell: this package only has one."
))


# Add testthat configuration parameters ----------------------------------------


usethis::use_testthat(edition = 3L, parallel = TRUE)


# Dependencies -----------------------------------------------------------------


usethis::use_package("R",              type = "Depends",  min_version = "4.0")
usethis::use_package("R6",             type = "Imports",  min_version = NULL)
usethis::use_package("covr",           type = "Suggests", min_version = NULL)
usethis::use_package("microbenchmark", type = "Suggests", min_version = NULL)
usethis::use_package("withr",          type = "Suggests", min_version = NULL)
