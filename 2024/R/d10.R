source("../../shared/R/matrix.R")

parse_file <- function(f = "../inputs/input_10.txt") {
  pad_matrix(strings_to_int_matrix(readLines(f)), pad_size = 1, with = -1)
}

explore <- function(d, x, y, h) {
  tot <- c()
  if (d[y, x] == 9) return ((y * ncol(d)) + x)
  if (d[y, x + 1] == h + 1) tot <- c(tot, explore(d, x + 1, y, h + 1))
  if (d[y, x - 1] == h + 1) tot <- c(tot, explore(d, x - 1, y, h + 1))
  if (d[y + 1, x] == h + 1) tot <- c(tot, explore(d, x, y + 1, h + 1))
  if (d[y - 1, x] == h + 1) tot <- c(tot, explore(d, x, y - 1, h + 1))
  tot
}

part1 <- function(d, p2 = FALSE) {
  heads <- which(d == 0, arr.ind = TRUE)
  tot <- 0
  for (h in seq_len(nrow(heads))) {
    co <- as.integer(heads[h, ])
    res <-  explore(d, co[2], co[1], 0)
    tot <- tot + if (p2) length(res) else length(unique(res))
  }
  tot
}

part2 <- function(d) {
  part1(d, TRUE)
}

d <- parse_file()
c(part1(d), part2(d))
