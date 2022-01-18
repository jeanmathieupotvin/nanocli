# .is() ------------------------------------------------------------------------


test_that(".is() applies its callback function on x", {
    expect_true(.is(logical(), is.logical))
    expect_false(.is(logical(), is.integer))
})

test_that(".is() enforces targetLength when it is appropriate", {
    expect_true(.is(logical(),   is.logical))
    expect_true(.is(logical(1L), is.logical, 1L))
    expect_false(.is(logical(),  is.logical, 1L))
})

test_that(".is() coerces targetLength to an integer if required", {
    expect_true(.is(logical(1L), is.logical, 1.0))
    expect_true(.is(logical(1L), is.logical, "1"))
})

test_that(".is() returns NA with a warning if targetLength cannot be coerced", {
    expect_warning(out <- .is(logical(1L), is.logical, "ERROR"))
    expect_identical(out, NA)
})

test_that(".is() always uses first element passed to targetLength only", {
    expect_true(.is(logical(1L), is.logical, c(1L, 1L)))
    expect_true(.is(logical(1L), is.logical, c("1", "2")))
})

test_that(".is() checks NAs if acceptNA is false", {
    expect_true(.is(NA, is.logical, NULL,  1L))
    expect_false(.is(NA, is.logical, NULL, FALSE))
})

test_that(".is() won't check NAs if acceptNA is not a strict false value", {
    expect_true(.is(NA, is.logical, NULL, "lol"))
    expect_true(.is(NA, is.logical, NULL, c(FALSE, FALSE)))
    expect_true(.is(NA, is.logical, NULL, NA))
})

test_that(".is() performs all required checks when appropriate", {
    expect_true(.is(logical(1L), is.logical, 1L, TRUE))
    expect_false(.is(logical(),  is.logical, 1L, TRUE))
    expect_false(.is(NA, is.logical, 1L, FALSE))
})


# isNull() ---------------------------------------------------------------------


test_that("isNull() works", {
    expect_true(isNull(NULL))
    expect_false(isNull(1L))
})


# Wrappers to .is() ------------------------------------------------------------


test_that("isLgl() works", {
    expect_true(isLgl(logical(1L)))
    expect_false(isLgl(logical(1L), 2L, TRUE))
    expect_false(isLgl(NA, 1L, FALSE))
})

test_that("isInt() works", {
    expect_true(isInt(integer(1L)))
    expect_false(isInt(integer(1L), 2L, TRUE))
    expect_false(isInt(NA_integer_, 1L, FALSE))
})

test_that("isDbl() works", {
    expect_true(isDbl(double(1L)))
    expect_false(isDbl(double(1L), 2L, TRUE))
    expect_false(isDbl(NA_real_, 1L, FALSE))
})

test_that("isCpx() works", {
    expect_true(isCpx(complex(1L)))
    expect_false(isCpx(complex(1L), 2L, TRUE))
    expect_false(isCpx(NA_complex_, 1L, FALSE))
})

test_that("isChr() works", {
    expect_true(isChr(character(1L)))
    expect_false(isChr(character(1L), 2L, TRUE))
    expect_false(isChr(NA_character_, 1L, FALSE))
})

test_that("isRaw() works", {
    expect_true(isRaw(raw(1L)))
    expect_false(isRaw(raw(1L), 2L))
})

test_that("isAtomic() works", {
    # We use logical values to test this generic
    # instrospector. It works for any atomic type.
    expect_true(isAtomic(logical(1L)))
    expect_false(isAtomic(logical(1L), 2L, TRUE))
    expect_false(isAtomic(NA, 1L, FALSE))
})

test_that("isScalarLgl() works", {
    expect_true(isScalarLgl(logical(1L)))
    expect_true(isScalarLgl(NA, TRUE))
    expect_false(isScalarLgl(logical()))
    expect_false(isScalarLgl(NA))
})

test_that("isScalarInt() works", {
    expect_true(isScalarInt(integer(1L)))
    expect_true(isScalarInt(NA_integer_, TRUE))
    expect_false(isScalarInt(integer()))
    expect_false(isScalarInt(NA_integer_))
})

test_that("isScalarDbl() works", {
    expect_true(isScalarDbl(double(1L)))
    expect_true(isScalarDbl(NA_real_, TRUE))
    expect_false(isScalarDbl(double()))
    expect_false(isScalarDbl(NA_real_))
})

test_that("isScalarCpx() works", {
    expect_true(isScalarCpx(complex(1L)))
    expect_true(isScalarCpx(NA_complex_, TRUE))
    expect_false(isScalarCpx(complex()))
    expect_false(isScalarCpx(NA_complex_))
})

test_that("isScalarChr() works", {
    expect_true(isScalarChr(character(1L)))
    expect_true(isScalarChr(NA_character_, TRUE))
    expect_false(isScalarChr(character()))
    expect_false(isScalarChr(NA_character_))
})

test_that("isScalarRaw() works", {
    expect_true(isScalarRaw(raw(1L)))
    expect_false(isScalarRaw(raw()))
})

test_that("isScalarAtomic() works", {
    # We use logical values to test this generic
    # instrospector. It works for any atomic type.
    expect_true(isScalarAtomic(logical(1L)))
    expect_true(isScalarAtomic(NA, TRUE))
    expect_false(isScalarAtomic(logical()))
    expect_false(isScalarAtomic(NA))
})
