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

d <- c(16,1,2,0,4,2,7,1,2,14)
stopifnot(isTRUE(all.equal(c(part1(d), part2(d)), c(37, 168))))

d <- as.integer(strsplit(readLines("../inputs/d07-input.txt"), ",")[[1]])
part1(d)
part2(d)
