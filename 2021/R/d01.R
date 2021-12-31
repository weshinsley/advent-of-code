part1 <- function(d) {
  sum(d[2:length(d)] > d[1:(length(d) - 1)])
}

part2 <- function(d) {
  sum(d[4:length(d)] > d[1:(length(d) - 3)])
}

d <- c(199, 200, 208, 210, 200, 207, 240, 269, 260, 263)
stopifnot(isTRUE(all.equal(c(part1(d), part2(d)), c(7,5))))

d <- as.integer(readLines("../inputs/d01-input.txt"))

part1(d)
part2(d)
