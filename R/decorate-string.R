#' Decorate a plain character string
#'
#' Decorate a character string by adding a prefix and/or suffix to it, and
#' by setting ANSI standardized SGR (*Select Graphic Rendition*) parameters
#' for it. These parameters are always scoped to the decorated string.
#'
#' @aliases DecoratedString
#'
#' @param string `[character(1)]`
#'
#'   A character string to be decorated. It cannot be empty.
#'
#' @param prefix `[character(1)]`
#'
#'   An optional character string to append to the beginning of `string`.
#'
#' @param suffix `[character(1)]`
#'
#'   An optional character string to append to the end of `string`.
#'
#' @param sgrSet `[integer()]`
#'
#'   An optional set of ANSI SGR parameters that adds one or more styles to
#'   `string`. Note that `prefix` and `suffix` also inherit these styles.
#'
#' @param sgrReset `[integer()]`
#'
#'   An optional set of ANSI SGR parameters that resets all styles previously
#'   set by SGR parameters passed to `sgrSet`.
#'
#'   The length of `sgrSet` and `sgrReset` must always match, even if this
#'   implies to duplicate certain parameters. Duplicates are handled internally.
#'
#' @param x `[DecoratedString]`
#'
#'   A [DecoratedString][decorateString()] object to print.
#'
#' @param ... `[any]`
#'
#'   Currently ignored.
#'
#' @returns A `character(1)` of S3 class [DecoratedString][decorateString()].
#'
#' @section The DecoratedString S3 class: This class does very little. It has
#'   a single [print()] method that conveys the object's internal value and
#'   its appearance when printed in a terminal.
#'
#' @examples
#' ## Create HTML tags.
#' decorateString("Here is some text.", "<p>", "</p>")
#'
#' ## Add ANSI styles, here bold text (SGR parameters 1 and 22).
#' decorateString("Here is some bold text.", sgrSet = 1L, sgrReset = 22L)
#'
#' ## All at once.
#' decorateString("Here is some bold text.", "<b>", "</b>", 1L, 22L)
#'
#' @export
decorateString <- function(
    string   = character(1L),
    prefix   = character(1L),
    suffix   = character(1L),
    sgrSet   = integer(),
    sgrReset = integer()) {
    if (!isScalarChr(string) || !nzchar(string)) {
        stop("\rTypeError: `string` must be a non-empty character string.",
             call. = FALSE)
    }
    if (!isScalarChr(prefix)) {
        stop("\rTypeError: `prefix` must be a character string.",
             call. = FALSE)
    }
    if (!isScalarChr(suffix)) {
        stop("\rTypeError: `suffix` must be a character string.",
             call. = FALSE)
    }

    # Each SGR parameter that sets a display attribute must
    # be reset via another SGR parameter. This ensures that
    # attributes are always scoped to the decorated string.
    if ({ paramsLength <- length(sgrSet) } != length(sgrReset)) {
        stop("lengths of `sgrSet` and `sgrReset` are not equal.\n",
             "Each SGR parameter that sets a display attribute ",
             "have an equivalent reset attribute.",
             call. = FALSE)
    }

    # Silently coerce SGR parameters to integer
    # vectors. Errors (NA values) are raised below.
    suppressWarnings({
        sgrSet   <- as.integer(sgrSet)
        sgrReset <- as.integer(sgrReset)
    })

    if (!isInt(sgrSet, NULL, FALSE)) {
        stop("\rTypeError: `sgrSet` must be an integer vector.\n",
             "It cannot contain NA values.",
             call. = FALSE)
    }
    if (!isInt(sgrReset, NULL, FALSE)) {
        stop("\rTypeError: `sgrReset` must be an integer vector.\n",
             "It cannot contain NA values.",
             call. = FALSE)
    }

    # Add prefix and suffix.
    # These should NOT be ANSI sequences.
    string <- sprintf("%s%s%s", prefix, string, suffix)

    if (paramsLength) {
        # Add ANSI sequences.
        string <- sprintf(
            "%s%s%s",
            .sgrCreateSequence(sgrSet),
            string,
            .sgrCreateSequence(sgrReset))
    }

    class(string) <- "DecoratedString"
    return(string)
}

#' @rdname decorateString
#' @export
print.DecoratedString <- function(x, ...) {
    cat("<DecoratedString>",
        sprintf("Value  : %s", deparse(x[[1L]])),
        sprintf("Output : %s", x),
        sep = "\n  ")

    return(invisible(x))
}
