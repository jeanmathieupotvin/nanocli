#' Entry point for developers
#'
#' Prepare an R session for development purposes.
#'
#' @note This script is (obviously) ignored in package's builds.

# Ensure that development dependencies can
# be loaded, and attach these packages to
# R's search path.
if (interactive()) {
    suppressMessages({
        require("devtools")
        require("usethis")
    })
}

# Create an alias for function microbenchmark::microbenchmark().
if (requireNamespace("microbenchmark", quietly = TRUE)) {
    bench <- microbenchmark::microbenchmark
}

# Create an alias for function data.table::address().
if (requireNamespace("data.table", quietly = TRUE)) {
    addr <- data.table::address
}
