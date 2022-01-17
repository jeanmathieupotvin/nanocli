#' Package's side-files
#'
#' Create and update the usual top-level side-files.


# Add records to .gitignore ----------------------------------------------------


usethis::use_git_ignore(ignores = c(
    ".Rproj.user",
    ".Rhistory",
    ".RData",
    ".Renviron",
    ".temp"
))


# Add records to .Rbuildignore -------------------------------------------------


usethis::use_build_ignore(escape = TRUE, files = c(
    ".github",
    ".temp",
    ".usethis",
    ".gitignore",
    ".Rproj.user",
    ".Rhistory",
    ".RData",
    ".Rproj",
    ".Rprofile",
    ".Renviron",
    "codecov.yml",
    "LICENSE.md"
))
