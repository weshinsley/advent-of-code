part1 <- function(d) {
  sum(d[2:length(d)] > d[1:(length(d) - 1)])
}

part2 <- function(d) {
  sum(d[4:length(d)] > d[1:(length(d) - 3)])
}

d <- as.integer(readLines("../inputs/input_1.txt"))
c(part1(d), part2(d))
