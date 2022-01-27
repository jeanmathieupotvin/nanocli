# collapseVector() -------------------------------------------------------------


test_that("collapseVector() works", {
    expect_identical(collapseVector(c(TRUE, FALSE)),    "TRUEFALSE")
    expect_identical(collapseVector(c(1L, 2L)),         "12")
    expect_identical(collapseVector(c(1.0, 2.0)),       "12")
    expect_identical(collapseVector(c(1.0+1i, 1.0+1i)), "1+1i1+1i")
    expect_identical(collapseVector(c("1", "2")),       "12")

    # Ensure it works with raw vectors.
    expect_identical(collapseVector(as.raw(c("0x01", "0x02"))), "0102")

    # Ensure it works with list, so-called generalized vectors.
    expect_identical(collapseVector(list(1L, 2L)), "12")
})


# replaceStringChars() -------------------------------------------------------


test_that("replaceStringChars() validates its arguments", {
    expect_error(replaceStringChars(1L))
    expect_error(replaceStringChars(NA_character_))
    expect_error(replaceStringChars("string", "1"))
    expect_error(replaceStringChars("string", NA_integer_))
    expect_error(replaceStringChars("string", 1L, 1L))
    expect_error(replaceStringChars("string", 1L, NA_character_))

    expect_snapshot(error = TRUE, {
        replaceStringChars(1L)
    })
    expect_snapshot(error = TRUE, {
        replaceStringChars("string", "1")
    })
    expect_snapshot(error = TRUE, {
        replaceStringChars("string", 1L, NA_character_)
    })
})

test_that("replaceStringChars() returns string as is if it or charsIndices is empty", {
    expect_identical(replaceStringChars(""), "")
    expect_identical(replaceStringChars("string"), "string")
})

test_that("replaceStringChars() throws an error if length of charsIndices is greater than the number of characters in string", {
    expect_snapshot(error = TRUE, {
        string <<- "string"
        charsIndices <- seq_len(nchar(string) + 1L)
        replaceStringChars(string, charsIndices)
    })
    expect_error(replaceStringChars(string, seq_len(nchar(string) + 1L)))
})

test_that("replaceStringChars() throws an error if length of replacement is greater than length of charsIndices", {
    expect_error(replaceStringChars("string", 1L, c("", "")))
    expect_snapshot(error = TRUE, {
        replaceStringChars("string", 1L, c("", ""))
    })
})

test_that("replaceStringChars() removes characters in string if replacement is empty", {
    expect_identical(replaceStringChars("string", c(1L, 2L)), "ring")
    expect_identical(replaceStringChars("string", seq_len(nchar("string"))), "")
})

test_that("replaceStringChars() performs specified replacements", {
    expect_identical(replaceStringChars("string", 2L, "%"),                "s%ring")
    expect_identical(replaceStringChars("string", c(2L, 3L), "%"),         "s%%ing")
    expect_identical(replaceStringChars("string", c(2L, 3L), c("%", "%")), "s%%ing")
    expect_identical(replaceStringChars("string", c(2L, 3L), c("", "%")),  "s%ing")
})
