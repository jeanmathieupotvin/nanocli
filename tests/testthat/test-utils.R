# .getDotsAsVector() -----------------------------------------------------------


test_that(".getDotsAsVector() destructures dots and returns a vector", {

    expect_identical(
        .getDotsAsVector(a = 1, b = 2, c = 3),
        c(a = 1, b = 2, c = 3))
    expect_identical(
        .getDotsAsVector(c(a = 1, b = 2, c = 3)),
        c(a = 1, b = 2, c = 3))
    expect_identical(
        .getDotsAsVector(list(a = 1, b = 2, list(c = 3)), 4, 5, 6),
        c(a = 1, b = 2, c = 3, 4, 5, 6))
})

test_that(".getDotsAsVector() returns null if dots are empty", {
    expect_null(.getDotsAsVector())
    expect_null(.getDotsAsVector(integer()))
    expect_null(.getDotsAsVector(list()))
    expect_null(.getDotsAsVector(integer(), list()))
})


# .simplifyInteger() -----------------------------------------------------------


test_that(".simplifyInteger() sorts vectors", {
    expect_identical(
        .simplifyInteger(c(2L, 1L, 4L, 3L)),
        c(1L, 2L, 3L, 4L))
})

test_that(".simplifyInteger() removes duplicates", {
    expect_identical(
        .simplifyInteger(c(2L, 1L, 3L, 3L)),
        c(1L, 2L, 3L))
})
