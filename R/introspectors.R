#' Introspectors
#'
#' Check types and lengths of \R objects. Decide whether [NA][base::NA]
#' values should be valid inputs or not.
#'
#' @name introspectors
#'
#' @param x `[any]`
#'
#'   Object to be tested.
#'
#' @param targetLength `[NULL | integer(1) | double(1)]`
#'
#'   Expected length of `x`. If `NULL`, no length is enforced. This parameter
#'   is automatically coerced to an [integer][base::integer].
#'
#' @param acceptNA `[logical(1)]`
#'
#'   Can `x` contain [NA][base::NA] values? Note that it makes no sense to
#'   check for [NA][base::NA] values in a [`raw`][base::raw()] vector.
#'
#'   By default, [NA][base::NA] are valid values, except when a scalar
#'   value is expected.
#'
#' @returns A `logical(1)`.
#'
#' @details [Atomic types][base::is.atomic()] are abbreviated for brevity:
#'   * `lgl` stands for `"logical"`,
#'   * `int` stands for `"integer"`,
#'   * `dbl` stands for `"double"`,
#'   * `cpx` stands for `"complex"`,
#'   * `chr` stands for `"character"`, and
#'   * `raw` stands for `"raw"`.
#'
#'   What \R sometimes call a [numeric][base::numeric()] is just a
#'   [double][base::double()]: a *double-precision vector*.
#'
#' @section Checking NULL values:
#'   A `NULL`'s length is always equal to 0. Therefore, [isNull()] is just
#'   an alias to function [is.null()][base::is.null()], and is provided for
#'   convenience. Note that `isAtomic(NULL)` yields `TRUE` because `NULL` is
#'   a degenerate atomic type.
#'
#' @examples
#' ## Check if a vector contains 3 double values.
#' isDbl(c(1.0, 1.1, 1.2), 3L)
#'
#' ## Beware of R's implicit conversions. This yields FALSE.
#' isInt(c(1L, 2, 3L))
#'
#' ## By default, NAs are accepted in vectors.
#' isInt(c(1L, NA_integer_))        # TRUE
#' isInt(c(1L, NA_integer_), FALSE) # FALSE
#'
#' ## By default, scalar values cannot be NA.
#' isScalarInt(NA_integer_)       # FALSE
#' isScalarInt(NA_integer_, TRUE) # TRUE
#'
#' @export
isNull <- function(x) {
    return(is.null(x))
}

#' @rdname introspectors
#' @export
isLgl <- function(x, targetLength = NULL, acceptNA = TRUE) {
    return(.is(x, is.logical, targetLength, acceptNA))
}

#' @rdname introspectors
#' @export
isInt <- function(x, targetLength = NULL, acceptNA = TRUE) {
    return(.is(x, is.integer, targetLength, acceptNA))
}

#' @rdname introspectors
#' @export
isDbl <- function(x, targetLength = NULL, acceptNA = TRUE) {
    return(.is(x, is.double, targetLength, acceptNA))
}

#' @rdname introspectors
#' @export
isCpx <- function(x, targetLength = NULL, acceptNA = TRUE) {
    return(.is(x, is.complex, targetLength, acceptNA))
}

#' @rdname introspectors
#' @export
isChr <- function(x, targetLength = NULL, acceptNA = TRUE) {
    return(.is(x, is.character, targetLength, acceptNA))
}

#' @rdname introspectors
#' @export
isRaw <- function(x, targetLength = NULL) {
    return(.is(x, is.raw, targetLength, TRUE))
}

#' @rdname introspectors
#' @export
isAtomic <- function(x, targetLength = NULL, acceptNA = TRUE) {
    return(.is(x, is.atomic, targetLength, acceptNA))
}

#' @rdname introspectors
#' @export
isScalarLgl <- function(x, acceptNA = FALSE) {
    return(.is(x, is.logical, 1L, acceptNA))
}

#' @rdname introspectors
#' @export
isScalarInt <- function(x, acceptNA = FALSE) {
    return(.is(x, is.integer, 1L, acceptNA))
}

#' @rdname introspectors
#' @export
isScalarDbl <- function(x, acceptNA = FALSE) {
    return(.is(x, is.double, 1L, acceptNA))
}

#' @rdname introspectors
#' @export
isScalarCpx <- function(x, acceptNA = FALSE) {
    return(.is(x, is.complex, 1L, acceptNA))
}

#' @rdname introspectors
#' @export
isScalarChr <- function(x, acceptNA = FALSE) {
    return(.is(x, is.character, 1L, acceptNA))
}

#' @rdname introspectors
#' @export
isScalarRaw <- function(x) {
    return(.is(x, is.raw, 1L))
}

#' @rdname introspectors
#' @export
isScalarAtomic <- function(x, acceptNA = FALSE) {
    return(.is(x, is.atomic, 1L, acceptNA))
}


# Generic introspector ---------------------------------------------------------


#' Generic introspector
#'
#' Check that x is of a type given by a callback function. Optionally,
#' enforce a specific length and accept or reject NA values.
#'
#' @name internal-is
#'
#' @param x `[any]`
#'     Object to be tested.
#' @param isCb `[function]`
#'     Callback function. Example: is.logical(). This is an internal parameter
#'     not visible by users.
#' @param targetlength `[NULL | integer(1) | double(1)]`
#'     Desired length of `x`. No length is enforced if this parameter is NULL.
#' @param acceptNA `[logical(1)]`
#'     Can `x` contain NA values?
#'
#' @returns A logical(1).
#'
#' @keywords internal
.is <- function(x, isCb, targetLength = NULL, acceptNA = TRUE) {
    # Type guards for acceptNA is enforced by isFALSE().
    if (isFALSE(acceptNA) && anyNA(x)) {
        return(FALSE)
    }

    if (is.null(targetLength)) {
        return(isCb(x))
    }

    # Type guard against plausible errors passed to targetLength.
    # We try to use a coercible scalar numeric value.
    return(isCb(x) && length(x) == as.integer(targetLength[[1L]]))
}
