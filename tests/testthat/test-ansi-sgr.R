# .sgrCreateSequence() ---------------------------------------------------------


test_that(".sgrCreateSequence() returns ansi-compliant strings", {
    expect_true(.sgrIsValidStrictSequence(.sgrCreateSequence()))
    expect_true(.sgrIsValidStrictSequence(.sgrCreateSequence(1L, 2L, 3L)))
})

test_that(".sgrCreateSequence() returns an empty sequence if dots are empty", {
    expect_identical(.sgrCreateSequence(), "\033[0m")
})

test_that(".sgrCreateSequence() returns a sequence with parameters passed to dots", {
    expect_identical(.sgrCreateSequence(1L, 2L, 3L), "\033[1;2;3m")
})

test_that(".sgrCreateSequence() removes duplicated parameters passed to dots", {
    expect_identical(.sgrCreateSequence(2L, 2L), "\033[2m")
})

test_that(".sgrCreateSequence() sorts parameters passed to dots", {
    expect_identical(.sgrCreateSequence(2L, 1L, 3L), "\033[1;2;3m")
})

test_that(".sgrCreateSequence() coerces parameters passed to dots to integer", {
    expect_identical(.sgrCreateSequence(2.45, "3.6"), "\033[2;3m")
})


# .sgrSimplifySequence() -------------------------------------------------------


test_that(".sgrSimplifySequence() works", {
    expect_identical(.sgrSimplifySequence("\033[1;2;3;3;2;1m"),    "\033[1;2;3m")
    expect_identical(.sgrSimplifySequence("\033[1;2m\033[3;2;1m"), "\033[1;2;3m")
    expect_identical(.sgrSimplifySequence("\033[1;2\033[3;2;1"),   "\033[1;2;3m")
})


# .sgrGetParameters() ----------------------------------------------------------


test_that(".sgrGetParameters() returns an empty integer vector if nothing can be extracted", {
    expect_identical(.sgrGetParameters("normal string"), integer())
})

test_that(".sgrGetParameters() works with strict sequences", {
    params <- c(1L, 2L, 3L)
    sgrSeq <- .sgrCreateSequence(params)

    expect_identical(.sgrGetParameters(sgrSeq),       params)
})

test_that(".sgrGetParameters() works with non-strict sequences", {
    expect_identical(.sgrGetParameters("\033[1;2m\033[3m"), c(1L, 2L, 3L))
})

test_that("sgrGetParameters() does not extract bad parameters", {
    expect_identical(.sgrGetParameters("\033[1;2;3"),  c(1L, 2L))
    expect_identical(.sgrGetParameters("\033[3;'4'm"), 3L)
})


# .sgrPushParameters() ---------------------------------------------------------


test_that(".sgrPushParameters works", {
    sgrSeq <- .sgrCreateSequence(1L, 2L)

    expect_identical(.sgrPushParameters(sgrSeq), sgrSeq)
    expect_identical(
        .sgrPushParameters(sgrSeq, 3L, 4L),
        .sgrCreateSequence(1L, 2L, 3L, 4L))
    expect_identical(
        .sgrPushParameters(sgrSeq, 1L, 2L),
        .sgrCreateSequence(1L, 2L))
    expect_identical(
        .sgrPushParameters(sgrSeq, 4L, 3L),
        .sgrCreateSequence(1L, 2L, 3L, 4L))
})


# .sgrPopParameters ------------------------------------------------------------


test_that(".sgrPopParameters works", {
    sgrSeq <- .sgrCreateSequence(1L, 2L)

    expect_identical(.sgrPopParameters(sgrSeq), sgrSeq)
    expect_identical(
        .sgrPopParameters(sgrSeq, 1L, 2L),
        .sgrCreateSequence())
    expect_identical(
        .sgrPopParameters(sgrSeq, 3L),
        .sgrCreateSequence(1L, 2L))
})


# .sgrIsValidStrictSequence() --------------------------------------------------


test_that(".sgrIsValidStrictSequence() works", {
    expect_true(.sgrIsValidStrictSequence("\033[m"))           # ansi empty sequence
    expect_true(.sgrIsValidStrictSequence("\033[1m"))          # one parameter
    expect_true(.sgrIsValidStrictSequence("\033[1;2m"))        # multiple parameters
    expect_true(.sgrIsValidStrictSequence("\033[1;2;33;453m")) # big parameters

    expect_false(.sgrIsValidStrictSequence("1;2;3m"))       # missing csi chars
    expect_false(.sgrIsValidStrictSequence("\033[1;2;3"))   # missing terminating char
    expect_false(.sgrIsValidStrictSequence("1;2;3m"))       # missing csi
    expect_false(.sgrIsValidStrictSequence("\0331;2;3m"))   # missing char in csi
    expect_false(.sgrIsValidStrictSequence("\033[1;;2;3m")) # duplicated separator
    expect_false(.sgrIsValidStrictSequence("\033[1;2.2m"))  # bad parameter
    expect_false(.sgrIsValidStrictSequence("\033[1;'2'm"))  # bad parameter
})

test_that("a non-strict sequence is not a strict sequence", {
    expect_false(.sgrIsValidStrictSequence("\033[1m\033[2m"))
})


# .sgrIsValidSequence() --------------------------------------------------------


test_that(".sgrIsValidSequence() works", {
    # Tests below are duplicates taken from tests
    # written for .sgrIsValidStrictSequence(). A
    # non-strict sequence is created by duplicating
    # the underlying strict sequence. Errors are
    # injected in either copy with no particular
    # preference.

    expect_true(.sgrIsValidSequence("\033[m\033[m"))
    expect_true(.sgrIsValidSequence("\033[1m\033[1m"))
    expect_true(.sgrIsValidSequence("\033[1;2m\033[1;2m"))
    expect_true(.sgrIsValidSequence("\033[1;2;33;453m\033[1;2;33;453m"))

    expect_false(.sgrIsValidSequence("1;2;3m\033[1;2;3m"))       # missing csi chars
    expect_false(.sgrIsValidSequence("\033[1;2;3\033[1;2;3m"))   # missing terminating char
    expect_false(.sgrIsValidSequence("1;2;3m\033[1;2;3m"))       # missing csi
    expect_false(.sgrIsValidSequence("\033[1;2;3m\0331;2;3m"))   # missing char in csi
    expect_false(.sgrIsValidSequence("\033[1;2;3m\033[1;;2;3m")) # duplicated separator
    expect_false(.sgrIsValidSequence("\033[1;2;3m\033[1;2.2m"))  # bad parameter
    expect_false(.sgrIsValidSequence("\033[1;'2'm\033[1;2;3m"))  # bad parameter

    expect_false(.sgrIsValidSequence("\033[1\033[1;;2;3m")) # error in both strict sequences
})

test_that("a strict sequence is also a non-strict sequence", {
    expect_true(.sgrIsValidSequence("\033[1m"))
})
