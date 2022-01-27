#' Coerce a vector to a single character string
#'
#' Create a character string from the values of a vector or a list.
#' This function is a shortcut to `paste0(x, collapse = "")`.
#'
#' @param x `[NULL | vector()]`
#'
#'   A so-called *generalized* vector: either `NULL`, an
#'   [atomic vector][base::vector()] or a [list][base::list()].
#'
#' @returns A `character(1)`.
#'
#' @details Function [strcoll()] is an alias to its semantic counterpart
#'   [collapseVector()]. It fits package \pkg{base}'s naming conventions
#'   for functions that operate with and on strings.
#'
#' @export
collapseVector <- function(x = vector()) {
    return(paste0(x, collapse = ""))
}

#' Replace or remove characters in a string
#'
#' Replace or remove characters at fixed positions in a string.
#'
#' @param string `[character(1)]`
#'
#'   A character string to be modified.
#'
#' @param indices `[integer()]`
#'
#'   Indices of individual characters to be removed and/or modified. Length
#'   of `indices` cannot be greater than the number of characters found in
#'   `string`.
#'
#'   Beware of indices that make no sense (like out-of-bounds indices), as
#'   their individual values are not checked before being used. They could
#'   lead to undefined behavior.
#'
#' @param replacement `[character()]`
#'
#'  Optional strings `[character(1)]` that should replace individual characters
#'  of `string`. They can be of any length, even `0`. An empty string implies
#'  that the underlying character should be removed from `string`.
#'
#'  Length of `replacement` cannot be greater than length of `indices`.
#'  However, it can be shorter. If so, elements will be recycled in the
#'  usual way.
#'
#' @returns A `character(1)`: either `string` or a sub-string created from it.
#'
#' @details This function can be considered as a generalized version of
#'   [substr<-()][base::substr()] and [substring<-()][base::substr()].
#'   It is much more predictable, and is fast enough to replace them in most
#'   situations. It does not support regular expressions. If you need to use
#'   them, consider using [sub()][base::grep()] or [gsub()][base::grep()]
#'   instead.
#'
#'   Function [strrepl()] is an alias to its semantic counterpart
#'   [replaceStringChars()]. It fits package \pkg{base}'s naming conventions
#'   for functions that operate with and on strings.
#'
#' @examples
#' ## Passing nothing to replaceStringChars() is allowed.
#' identical(replaceStringChars("string"), "string") # TRUE
#' identical(replaceStringChars(""), "") # TRUE
#'
#' ## Remove characters.
#' identical(replaceStringChars("string", 1L), "tring") # TRUE
#' identical(replaceStringChars("string", c(1L, 2L)), "ring") # TRUE
#' identical(replaceStringChars("string", c(1L, 2L), c("", "")), "ring") # TRUE
#'
#' ## Replace characters.
#' identical(replaceStringChars("string", c(1L, 2L), c("S", "T")), "STring") # TRUE
#' identical(replaceStringChars("string", c(1L, 2L), c("S", "")), "Sring") # TRUE
#' identical(replaceStringChars("string", c(1L, 2L), c("sub", "St")), "subString") # TRUE
#'
#' ## Replace and remove at once.
#' identical(replaceStringChars("string", c(1L, 2L), c("S", "")), "Sring") # TRUE
#'
#' ## Using semantic names or aliases does not matter.
#' identical(replaceStringChars("a", 1L), strrepl("a", 1L))
#'
#' ## Remember to store the resulting sub-string. It is NOT modified in place.
#' string <- "test"
#' identical(replaceStringChars(string, c(2L, 3L)), "tt") # TRUE
#' identical(string, "tt") # FALSE
#'
#' @export
replaceStringChars <- function(
    string      = character(1L),
    indices     = integer(),
    replacement = character())
{
    if (!isScalarChr(string)) {
        stop("\rTypeError: `string` must be a character string.",
             call. = FALSE)
    }
    if (!isInt(indices, NULL, FALSE)) {
        stop("\rTypeError: `indices` must be an integer vector.\n",
             "It cannot contain NA values.",
             call. = FALSE)
    }
    if (!isChr(replacement, NULL, FALSE)) {
        stop("\rTypeError: `replacement` must be a character vector.\n",
             "It cannot contain NA values.",
             call. = FALSE)
    }

    # If string is empty or if no index is specified,
    # nothing needs to be replaced or removed, and
    # string is simply returned.
    if (!nzchar(string) ||
        !{ indicesLen <- length(indices) }) {
        return(string)
    }

    if (indicesLen > nchar(string)) {
        stop("\rLogicError: length of `indices` cannot be",
             " greater than the number of characters in `string`.",
             call. = FALSE)
    }

    # Split string into a vector of individual characters.
    chars <- strsplit(string, "", TRUE)[[1L]]

    # If there is no replacement to perform, we remove
    # specified characters and return a sub-string.
    if (!{ repLen <- length(replacement) }) {
        return(collapseVector(chars[-indices]))
    }

    if (repLen > indicesLen) {
        stop(
            "\rLogicError: length of `replacement` cannot",
            " be greater than length of `indices`.\n",
            "However, it can be shorter. If so, `replacement`",
            " is recycled accordingly.",
            call. = FALSE)
    }

    # Suppress warnings stemming from unequal recycling
    # of replacement. This is a documented feature here,
    # no need to annoy user.
    suppressWarnings({
        chars[indices] <- replacement
    })

    return(collapseVector(chars))
}

#' @rdname collapseVector
#' @export
strcoll <- collapseVector

#' @rdname replaceStringChars
#' @export
strrepl <- replaceStringChars
