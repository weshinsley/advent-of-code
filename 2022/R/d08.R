parse <- function(file) {
  d <- lapply(readLines(file), function(x) utf8ToInt(x) - 48)
  matrix(data = unlist(d), nrow = length(d), byrow = TRUE)
}

`%||%` <- function(a, b) {
  if (is.na(a)) b else a
}

part1 <- function(d, vis = 0, size = dim(d)[1], range = 2:(size - 1)) {
  for (j in range) {
    for (i in range) {
      me <- d[j, i]
      if ((all(d[1:(j - 1), i] < me)) ||
          (all(d[(j + 1):size, i] < me)) ||
          (all(d[j, 1:(i - 1)] < me)) ||
          (all(d[j, (i + 1):size] < me))) vis <- vis + 1
    }
  }
  vis + (size * 4) - 4
}

loop <- function(d, limit, i = 1, ld = length(d)) {
  while (d[i] < limit) {
    i <- i + 1
    if (i > ld) return(NA)
  }
  i
}

part2 <- function(d, size = dim(d)[1], best = 0, range = 2:(size - 1)) {
  for (j in range) {
    for (i in range) {
      me <- d[j, i]
      best <- max(best,
        loop(d[j, (i - 1):1], me) %||% (i - 1) *
        loop(d[j, (i + 1):size], me) %||% (size - i) *
        loop(d[(j - 1):1, i], me) %||% (j - 1) *
        loop(d[(j + 1):size, i], me) %||% (size - j))
    }
  }
  best
}

input <- parse("../inputs/input_8.txt")
c(part1(input), part2(input))
