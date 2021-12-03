#' Package development process' history
#'
#' Audit trail of various functions calls related to the development process
#' of the package. It can be used to (partially) re-generate this package's
#' structure code programmatically.
#'
#' @note This script is (obviously) ignored in package's builds.


# Initialize package's skeleton ------------------------------------------------


usethis::create_package(".")
usethis::create_project(".")

# Remove name from .Rproj. It is useless.
file.rename("nanotools.Rproj", ".Rproj")


# Initialize Git repository ----------------------------------------------------


usethis::git_default_branch_configure(name = "main")
usethis::use_git()
usethis::use_git_remote(
    name = "origin",
    url  = "git@github.com:jeanmathieupotvin/nanotools.git")


# Add records to .gitignore ----------------------------------------------------


usethis::use_git_ignore(ignores = c(
    ".Rproj.user",
    ".Rhistory",
    ".Rdata",
    ".Renviron",
    ".temp"
))


# Create an entry point for developers -----------------------------------------


usethis::use_devtools()
usethis::use_usethis()


# Add records to .Rbuildignore -------------------------------------------------


usethis::use_build_ignore(escape = TRUE, files = c(
    ".gitignore",
    ".github",
    ".Rproj",
    ".Rproj.user",
    ".Rprofile",
    ".Renviron",
    "codecov.yml",
    "usethis.R",
    "LICENSE.md",
    "temp"
))


# Build DESCRIPTION file -------------------------------------------------------


usethis::use_description(check_name = TRUE, roxygen = TRUE, fields = list(
    Package          = "nanotools",
    Title            = "Simpler Alternatives to R Features",
    License          = "MIT + file LICENSE",
    Language         = "en",
    Encoding         = "UTF-8",
    ByteCompile      = "true",
    NeedsCompilation = "no",
    Roxygen          = "list(markdown = TRUE, r6 = TRUE)",
    URL              = "https://github.com/jeanmathieupotvin/nanotools",
    BugReports       = "https://github.com/jeanmathieupotvin/nanotools/issues/new",
    `Authors@R`      = 'utils::person(
        given   = "Jean-Mathieu",
        family  = "Potvin",
        email   = "jm@potvin.xyz",
        role    = c("aut", "cre"),
        comment = c(ORCID = "0000-0002-8237-422X"))',
    Description = "
        A toolbox of simpler alternatives and wrapper functions to
        R features. The intent is threefold: simplify features whenever
        possible (keep it simple), minimize reliance on dependencies
        (keep it small), and provide pure R alternatives that are as
        fast and efficient as possible (keep it fast)."
))


# Bump version field -----------------------------------------------------------


# Format is major.minor.patch.dev. Each component
# is updated whenever required using calls below.
usethis::use_version(which = "patch")
usethis::use_version(which = "dev")


# Choose license and create underlying files -----------------------------------


usethis::use_mit_license("Jean-Mathieu Potvin")


# Create a news file -----------------------------------------------------------


usethis::use_news_md()


# Create a read-me file --------------------------------------------------------


usethis::use_readme_md()
usethis::use_cran_badge()
usethis::use_lifecycle_badge(stage = "experimental")


# Setup dependencies -----------------------------------------------------------


# Required dependencies.
usethis::use_package("R", type = "Depends", min_version = "4.0")

# Imported packages.
usethis::use_package("cli", type = "Imports", min_version = "3.1")
usethis::use_package("R6",  type = "Imports", min_version = NULL)

# Suggested packages.
usethis::use_package("covr",           type = "Suggests", min_version = NULL)
usethis::use_package("microbenchmark", type = "Suggests", min_version = NULL)
usethis::use_package("withr",          type = "Suggests", min_version = NULL)


# Setup testing framework / environment ----------------------------------------


usethis::use_testthat(edition = 3L, parallel = TRUE)


# Setup continuous integration framework / environment (CI) --------------------


usethis::use_github_action_check_standard()


# Setup Codecov (CI) -----------------------------------------------------------


usethis::use_coverage("codecov")
usethis::use_github_action("test-coverage")


# Setup source files -----------------------------------------------------------


usethis::use_r(name = "nanotools-package")
