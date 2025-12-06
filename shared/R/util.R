vlapply <- function(...) {
  vapply(..., FUN.VALUE = TRUE)
}

vnapply <- function(...) {
  vapply(..., FUN.VALUE = 1)
}
