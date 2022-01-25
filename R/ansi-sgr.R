# Important notes for developers -----------------------------------------------


# Function gregexpr() returns a list equal to length(text), where text is
# its second argument. Moreover, the 'g' in gregexpr() implies it returns
# all matches, not just the first one (like what regexpr() would do). In
# this script, we always use gregexpr() to work on all matches.

# Argument perl is TRUE most of the time for performance and to access
# information on capturing groups. We do not use perl for fixed searches.

# Functions below are meant to be building blocks of higher-order functions.
# They always expect a string (character of length 1) as their main input,
# and no type check is done at runtime for better performance. Always check
# that argument string is a character(1), else you will run into undefined
# behavior.


# Fast benchmark of API --------------------------------------------------------


# seq       <- .sgrCreateSequence(1L, 2L, 3L)
# seqStrict <- sprintf("%s%s", seq, seq)

# bench(
#     create      = .sgrCreateSequence(1L, 2L, 3L),
#     simplify    = .sgrSimplifySequence(seqStrict),
#     get         = .sgrGetParameters(seq),
#     push        = .sgrPushParameters(seq, 8L, 9L),
#     pop         = .sgrPopParameters(seq,  3L, 2L),
#     isStrictSeq = .sgrIsValidStrictSequence(seq),
#     isSeq       = .sgrIsValidSequence(seqStrict),
#     times = 1000L)


# API --------------------------------------------------------------------------


#' Low-level API to manipulate ANSI sequences of SGR parameters
#'
#' @description Create sequences of SGR parameters, assess their validity, and
#'   manipulate their components.
#'
#'   These functions are collectively considered to be a CRUD (*Create*, *Read*,
#'   *Update*, *Delete*) interface to ANSI sequences holding SGR parameters.
#'   They are meant to be used as building blocks of higher-order functions.
#'
#' @name dot-api-sgr
#'
#' @param string `[character(1)]`
#'
#'   An ANSI sequence of SGR parameters.
#'
#' @param ... `[integer() | list()]`
#'
#'   Any number of \R structures containing integer values (possibly)
#'   representing SGR parameters. No coercion is done.
#'
#' @details A *valid* ANSI sequence can be strict or non-strict.
#'
#'   ## Strict sequences
#'
#'   A string is a *strictly valid* ANSI sequence if these threee criteria
#'   are met.
#'
#'   1. It begins by the CSI (*Control Sequence Introducer*) string `\033[`,
#'   where `\033` is the octal representation of the ASCII `ESC` character.
#'   2. It ends with a single `m` character.
#'   3. It encloses an arbitrary number of unquoted SGR parameters (integer
#'   values) all followed by a single `;` character (except for the last
#'   one who is followed by the terminating character `m`).
#'
#'   Examples of strictly valid sequences are strings like `\033[0m`
#'   and `\033[1;2;33m`.
#'
#'   ## Non-strict sequences
#'
#'   A string is a *non-strictly valid* ANSI sequence if it is composed of one
#'   or multiple strictly valid sequences concatenated together. Examples of
#'   such sequences are strings like `\033[1m\033[2;3m` and
#'   `\033[0m\033[5;66m`.
#'
#' @returns This depends on the function used.
#'
#' * [.sgrCreateSequence()], [.sgrSimplifySequence()], [.sgrPushParameters()],
#' and [.sgrPopParameters()] return a `character(1)` representing a strictly
#' valid ANSI sequence of SGR parameters.
#' * [.sgrGetParameters()] returns an `integer()` holding valid SGR parameters
#' extracted from an ANSI sequence. This sequence needs not to be either valid
#' or strict.
#' * [.sgrIsValidStrictSequence()] and [.sgrIsValidSequence()] return a
#' `logical(1)`. See section Details for the difference between strict
#' and non-strict sequences.
#'
#' @note All these functions perform no input validation at runtime. Failing
#'   to pass valid parameters leads to undefined behavior. Because of that,
#'   they should always be wrapped into higher-order functions.
#'
#' @keywords internal
.sgrCreateSequence <- function(...) {
    if (isNull(dots <- .getDotsAsVector(...))) {
        return("\033[0m")
    }

    return(sprintf("\033[%sm", paste0(.simplifyInteger(as.integer(dots)), collapse = ";")))
}

#' @rdname dot-api-sgr
#' @keywords internal
.sgrSimplifySequence <- function(string = character(1L)) {
    return(.sgrCreateSequence(.sgrGetParameters(string)))
}

#' @rdname dot-api-sgr
#' @keywords internal
.sgrGetParameters <- function(string = character(1L)) {
    # - [0-9]+ captures any integer number one or more times.
    # - (?=;|m) captures only mumbers followed by a separator,
    #   either ; or m. This separator is excluded from the match.
    regex <- gregexpr("[0-9]+(?=;|m)", string, perl = TRUE)[[1L]]

    if (regex[[1L]] == -1L) {
        # Return an empty integer() vector in case
        # of no match (no detected SGR parameter).
        return(integer())
    }

    matchLens <- attr(regex, "match.length")

    return(as.integer(substring(string, regex, regex + matchLens - 1L)))
}

#' @rdname dot-api-sgr
#' @keywords internal
.sgrPushParameters <- function(string = character(1L), ...) {
    if (isNull(dots <- .getDotsAsVector(...))) {
        return(string)
    }

    return(.sgrCreateSequence(.sgrGetParameters(string), dots))
}

#' @rdname dot-api-sgr
#' @keywords internal
.sgrPopParameters <- function(string = character(1L), ...) {
    if (isNull(dots <- .getDotsAsVector(...))) {
        return(string)
    }

    oldParams <- .sgrGetParameters(string)
    newParams <- oldParams[match(oldParams, dots, 0L) == 0L]

    return(.sgrCreateSequence(newParams))
}

#' @rdname dot-api-sgr
#' @keywords internal
.sgrIsValidStrictSequence <- function(string = character(1L)) {
    # A strict sequence starts with the ANSI
    # CSI (\033[) and ends with a single letter m.
    if (!startsWith(string, "\033[") || !endsWith(string, "m")) {
        return(FALSE)
    }

    if ({ nchrs <- nchar(string) } == 3L) {
        # The empty sequence "\033[m"
        # is valid accoridng to ANSI.
        return(TRUE)
    }

    # A strict sequence contains an arbitrary number
    # of integer values followed by a separator (;)
    # or the ending character m. We get the total
    # length of all these parameters.
    # - [0-9]* captures any integer number zero or more times.
    # - (?=;[0-9]+|m$) captures numbers that are followed by
    #   a separator AND another number OR by the terminating
    #   character (m$), without including what actually follows
    #   the captured number.
    regex <- gregexpr("[0-9]+(?=;[0-9]+|m$)", string, perl = TRUE)[[1L]]
    controlSum <- sum(attr(regex, "match.length"))

    # A strict sequence is valid if its controlSum is equal
    # to its total number of characters after having removed
    # the CSI, and all separators (; or m). There should be
    # one separator for each extracted parameter.
    if (controlSum != nchar(string) - 2L - length(regex)) {
        return(FALSE)
    }

    return(TRUE)
}

#' @rdname dot-api-sgr
#' @keywords internal
.sgrIsValidSequence <- function(string = character(1L)) {
    # A sequence can be strict or not. A non-strict
    # sequence is a string composed of one or more
    # strict sequences concatenated together.
    # Example: \033[1;2m\033[4;5m.

    # Split a sequence into a set of strict sequences.
    strictSeqs <- substring(string,
        first = gregexpr("\033[", string, fixed = TRUE)[[1L]],
        last  = gregexpr("m", string, fixed = TRUE)[[1L]])

    # A non-strict sequence is valid if all its strict sequences are valid.
    return(all(vapply(strictSeqs, .sgrIsValidStrictSequence, NA)))
}
