solve <- function(d, steps) {
  tab <- rep(0, 9)
  for (i in 0:8) {
    tab[i + 1] <- sum(d == i)
  }
  for (i in seq_len(steps)) {
    births <- tab[1]
    tab <- c(tab[-1], births)
    tab[7] <- tab[7] + births
  }
  sum(tab)
}

options(digits = 14)

part1 <- function(d) { solve(d, 80) }
part2 <- function(d) { solve(d, 256) }

stopifnot(part1(c(3, 4, 3, 1, 2)) == 5934)
stopifnot(part2(c(3, 4, 3, 1, 2)) == 26984457539)

d <- as.integer(strsplit(readLines("../inputs/d06-input.txt"), ",")[[1]])
part1(d)
part2(d)
