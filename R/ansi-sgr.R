sgrCreateSequence <- function(...) {
    dots <- if (...length() && length(..1) > 1L) {
        # If first element passed to ... is not a scalar
        # value, then we create a sequence using only
        # values of that first element. This is useful
        # for calls like sgrCreateSequence(c(1,2,3)).
        ..1
    } else {
        # Else, we use all values passed to ... .
        # This corresponds to calls like
        # sgrCreateSequence(1, 2, 3).
        c(...)
    }

    if (!length(dots)) {
        return("\033[0m")
    }

    # Coercing dots to integers before creating the
    # sequences is a type guard. SGR parameters are
    # integers.
    return(sprintf("\033[%sm", paste0(as.integer(dots), collapse = ";")))
}

sgrSimplifySequence <- function(sgrSeq = character(1L)) {
    sgrParams <- sgrExtractParameters(sgrSeq)
    return(sgrCreateSequence(sort.int(sgrParams[!duplicated(sgrParams)])))
}

sgrExtractParameters <- function(sgrSeq = character(1L)) {
    # Set perl to TRUE to access information on capturing groups.
    regex <- regexpr("\033\\[(.*?)m", sgrSeq, perl = TRUE)

    if (!regex) {
        # Return an empty integer() vector in case of no match
        # (no detected SGR parameter).
        return(integer(0L))
    }

    sgrStart  <- attr(regex, "capture.start")
    sgrParams <- substr(sgrSeq,
        sgrStart,
        sgrStart + attr(regex, "capture.length") - 1L) |>
        strsplit(split = ";", fixed = TRUE)

    return(as.integer(sgrParams[[1L]]))
}

sgrAddParameters <- function(sgrSeq = character(1L), sgrParams = integer()) {
    return(invisible())
}

sgrRemoveParameters <- function(sgrSeq = character(1L), sgrParams = integer()) {
    return(invisible())
}

sgrDetectSequences <- function(...) {
    return(invisible())
}
