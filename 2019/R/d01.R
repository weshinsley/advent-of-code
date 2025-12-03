part1 <- function(mass) {
  floor(mass/3) - 2
}

part2 <- function(mass) {
  f <- floor(mass/3) - 2
  if (f > 0) f + part2(f)
  else 0
}

input <- as.integer(readLines("../inputs/input_1.txt"))
c(sum(part1(input)),
  sum(unlist(lapply(input, part2))))
