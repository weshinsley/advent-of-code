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

d <- as.integer(strsplit(readLines("../inputs/input_6.txt"), ",")[[1]])
c(part1(d), part2(d))
