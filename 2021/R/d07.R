part1 <- function(d) {
  best <- -1
  for (i in seq_along(d)) {
    fuel <- sum(abs(d-i))
    if ((fuel < best) || (best == -1)) {
      best <- fuel
    }
  }
  best
}

# Slow. But fix later.

part2 <- function(d) {
  best <- -1
  for (i in seq_along(d)) {
    fuel <- 0
    for (j in seq_along(d)) {
      fuel <- fuel + sum(seq_len(abs(d[j]- i)))
    }
    if ((fuel < best) || (best==-1)) {
      best <- fuel
    }
  }
  best
}

d <- as.integer(strsplit(readLines("../inputs/input_7.txt"), ",")[[1]])
c(part1(d), part2(d))
