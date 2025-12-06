hash_new <- function() {
  new.env()
}

hash_contains <- function(hash, xs) {
  unlist(lapply(xs, function(y) exists(y, envir = hash)))
}

hash_put <- function(hash, xs, ys) {
  ys <- if (length(ys) == 1) rep(ys, length(xs)) else ys
  stopifnot(length(xs) == length(ys))
  for (i in seq_along(xs)) {
    assign(as.character(xs[i]), ys[i], envir = hash)
  }
}

hash_set_all <- function(hash, val) {
  hash_put(hash, ls(hash), val)
}

hash_inc <- function(hash, xs, ys) {
  ys <- if (length(ys) == 1) rep(ys, length(xs)) else ys
  stopifnot(length(xs) == length(ys))
  for (i in seq_along(xs)) {
    x <- as.character(xs[i])
    y <- ys[i]
    prev <- if (exists(x, envir = hash)) get(x, envir = hash) else 0
    assign(as.character(x), prev + y, envir = hash)
  }
}

hash_get <- function(hash, x) {
  x <- as.character(x)
  if (exists(x, envir = hash)) return(get(x, envir = hash))
  NULL
}

hash_copy <- function(src, dest) {
  for (num in ls(src)) {
    assign(num, get(num, envir = src), envir = dest)
  }
}

hash_sum <- function(hash) {
  tot <- 0
  for (num in ls(hash)) {
    tot <- tot + get(num, envir = hash)
  }
  tot
}

hash_keys <- function(hash) {
  ls(hash)
}
