# decorateString() -------------------------------------------------------------


test_that("decorateString() returns a DecoratedString", {
    expect_type(decorateString("string"), "character")
    expect_s3_class(decorateString("string"), "DecoratedString")
})

test_that("decorateString() validates its arguments", {
    expect_error(decorateString(""))
    expect_error(decorateString(1L))
    expect_error(decorateString("string", prefix = 1L))
    expect_error(decorateString("string", suffix = 1L))
    expect_error(decorateString("string", sgrSet = c(1L, 2L), sgrReset = 22L))
    expect_error(decorateString("string", sgrSet = "error",   sgrReset = 22L))
    expect_error(decorateString("string", sgrSet = 1L,        sgrReset = "error"))

    expect_snapshot(error = TRUE, {
        decorateString("")
    })
    expect_snapshot(error = TRUE, {
        decorateString(1L)
    })
    expect_snapshot(error = TRUE, {
        decorateString("string", prefix = 1L)
    })
    expect_snapshot(error = TRUE, {
        decorateString("string", suffix = 1L)
    })
    expect_snapshot(error = TRUE, {
        decorateString("string", sgrSet = c(1L, 2L), sgrReset = 22L)
    })
    expect_snapshot(error = TRUE, {
        decorateString("string", sgrSet = "error", sgrReset = 22L)
    })
    expect_snapshot(error = TRUE, {
        decorateString("string", sgrSet = 1L, sgrReset = "error")
    })
})

test_that("decorateString() coerces SGR parameters if possible", {
    expect_identical(
        decorateString("string", sgrSet = "1", sgrReset = "22"),
        "\033[1mstring\033[22m",
        ignore_attr = TRUE)
    expect_identical(
        decorateString("string", sgrSet = 1.2, sgrReset = 22.1),
        "\033[1mstring\033[22m",
        ignore_attr = TRUE)
})

test_that("decorateString() adds prefix and suffix to string", {
    string <- "String"
    prefix <- "Prefix"
    suffix <- "Suffix"

    expect_identical(
        decorateString(string, prefix),
        paste0(prefix, string),
        ignore_attr = TRUE)
    expect_identical(
        decorateString(string, "", suffix),
        paste0(string, suffix),
        ignore_attr = TRUE)
    expect_identical(
        decorateString(string, prefix, suffix),
        paste0(prefix, string, suffix),
        ignore_attr = TRUE)
})


# print.DecoratedString() ------------------------------------------------------


test_that("decorateString() adds ANSI sequences to string", {
    expect_identical(
        decorateString("string", "", "", 1L, 22L),
        "\033[1mstring\033[22m",
        ignore_attr = TRUE)
})

test_that("print.DecoratedString() works", {
    expect_snapshot({
        decoratedString <<- decorateString("allo!", "<b>", "</b>", 1L, 22L)
        print(decoratedString)
    })

    expect_s3_class(print(decoratedString), "DecoratedString")
    expect_invisible(print(decoratedString))
})
