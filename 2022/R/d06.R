part1 <- function(d, x = 4, i = x) {
  while (i < length(d)) {
    if (anyDuplicated(d[(i - (x - 1)):i]) == 0) return(i)
    i <- i + 1
  }
}

part2 <- function(d) {
  part1(d, 14)
}

d <- utf8ToInt(readLines("../inputs/input_6.txt"))
c(part1(d), part2(d))
