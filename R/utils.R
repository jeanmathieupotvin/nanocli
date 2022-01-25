#' Destructure parameters passed to ...
#'
#' Destructure all values passed to ... and return a (possibly named)
#' vector containing all values passed directly and/or indirectly to
#' ...
#'
#' @param ... `[any]`
#'
#'   Any \R object(s).
#'
#' @returns A vector of a type given by the highest one when following \R's
#' usual [type hierarchy][base::c()]. Names are preserved. `NULL` is returned
#' if the resulting vector is empty.
#'
#' @keywords internal
.getDotsAsVector <- function(...) {
    # c() combines all elements and return a recursive
    # structure if any ...<n> is recursive. We unlist
    # ensures that a vector is returned.
    if (length(dots <- unlist(c(...)))) {
        return(dots)
    } else {
        return(NULL)
    }
}

#' Simplify an integer vector
#'
#' Remove duplicates from an integer vector and sort the remaining values
#' in ascending order. This function is optimized for small vectors.
#'
#' @param int `[integer()]`
#'
#'   An integer vector.
#'
#' @returns An integer vector with a length no greater than the length
#'   of `int`.
#'
#' @keywords internal
.simplifyInteger <- function(int = integer()) {
    return(
        sort.int(int[!duplicated(int)], decreasing = FALSE, method = "radix"))
}