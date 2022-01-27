# decorateString() validates its arguments

    Code
      decorateString("")
    Error <simpleError>
      TypeError: `string` must be a non-empty character string.

---

    Code
      decorateString("string", prefix = 1L)
    Error <simpleError>
      TypeError: `prefix` must be a character string.

---

    Code
      decorateString("string", suffix = 1L)
    Error <simpleError>
      TypeError: `suffix` must be a character string.

---

    Code
      decorateString("string", sgrSet = c(1L, 2L), sgrReset = 22L)
    Error <simpleError>
      LogicError: lengths of `sgrSet` and `sgrReset` are not equal.
      Each SGR parameter that sets a display attribute must have an equivalent reset attribute.

---

    Code
      decorateString("string", sgrSet = "error", sgrReset = 22L)
    Error <simpleError>
      TypeError: `sgrSet` must be an integer vector.
      It cannot contain NA values.

---

    Code
      decorateString("string", sgrSet = 1L, sgrReset = "error")
    Error <simpleError>
      TypeError: `sgrReset` must be an integer vector.
      It cannot contain NA values.

# print.DecoratedString() works

    Code
      decoratedString <<- decorateString("allo!", "<b>", "</b>", 1L, 22L)
      print(decoratedString)
    Output
      <DecoratedString>
        Value  : "\033[1m<b>allo!</b>\033[22m"
        Output : [1m<b>allo!</b>[22m

