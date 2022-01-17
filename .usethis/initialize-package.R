#' Package initialization
#'
#' Function calls used to initialize package and its related side-files.


# Initialize package -----------------------------------------------------------


usethis::create_package(".")


# Initialize Git repository ----------------------------------------------------


usethis::git_default_branch_configure(name = "main")
usethis::use_git()
usethis::use_git_remote(
    name      = "origin",
    url       = "git@github.com:jeanmathieupotvin/nanocli.git",
    overwrite = TRUE)


# Initialize side-files --------------------------------------------------------


usethis::use_mit_license("Jean-Mathieu Potvin")
usethis::use_news_md()
usethis::use_readme_md()
usethis::use_cran_badge()
usethis::use_lifecycle_badge(stage = "experimental")


# Setup continuous integration framework / environment (CI) --------------------


usethis::use_github_action_check_standard()
usethis::use_github_action("test-coverage")
usethis::use_coverage("codecov")
