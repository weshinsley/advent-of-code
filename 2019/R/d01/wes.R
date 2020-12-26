library(testthat)

part1 <- function(mass) {
  floor(mass/3) - 2
}

part2 <- function(mass) {
  f <- floor(mass/3) - 2
  if (f > 0) f + part2(f)
  else 0
}

expect_equal(part1(12), 2)
expect_equal(part1(14), 2)
expect_equal(part1(1969),654)
expect_equal(part1(100756), 33583)
expect_equal(part2(14), 2)
expect_equal(part2(1969),966)
expect_equal(part2(100756), 50346)

input <- as.integer(readLines("d01/wes-input.txt"))
sum(part1(input))
sum(unlist(lapply(input, part2)))
