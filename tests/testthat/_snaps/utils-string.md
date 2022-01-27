# replaceStringChars() validates its arguments

    Code
      replaceStringChars(1L)
    Error <simpleError>
      TypeError: `string` must be a character string.

---

    Code
      replaceStringChars("string", "1")
    Error <simpleError>
      TypeError: `indices` must be an integer vector.
      It cannot contain NA values.

---

    Code
      replaceStringChars("string", 1L, NA_character_)
    Error <simpleError>
      TypeError: `replacement` must be a character vector.
      It cannot contain NA values.

# replaceStringChars() throws an error if length of charsIndices is greater than the number of characters in string

    Code
      string <<- "string"
      charsIndices <- seq_len(nchar(string) + 1L)
      replaceStringChars(string, charsIndices)
    Error <simpleError>
      LogicError: length of `indices` cannot be greater than the number of characters in `string`.

# replaceStringChars() throws an error if length of replacement is greater than length of charsIndices

    Code
      replaceStringChars("string", 1L, c("", ""))
    Error <simpleError>
      LogicError: length of `replacement` cannot be greater than length of `indices`.
      However, it can be shorter. If so, `replacement` is recycled accordingly.

