source("../../shared/R/matrix.R")

parse_file <- function(f = "../inputs/input_4.txt") {
  pad_matrix(strings_to_char_matrix(readLines(f)), pad_size = 3, with = " ")
}

part1 <- function(d, n = nrow(d)) {
  dxy <- c(1, -1, -n, n, n + 1, n - 1, -n + 1, -n - 1)
  sum(unlist(lapply(which(d == "X"), function(pos) lapply(dxy, function(delta)
    all(d[pos + delta * 1:3] == c("M", "A", "S"))))))
}

part2 <- function(d, n = nrow(d)) {
  sum(unlist(lapply(which(d == "A"), function(pos)
    setequal(c(d[pos - n - 1], d[pos + n + 1]), c("M", "S")) &&
    setequal(c(d[pos - n + 1], d[pos + n - 1]), c("M", "S")))))
}

d <- parse_file()
c(part1(d), part2(d))
