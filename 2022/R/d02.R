combos <- c("A X", "B X", "C X", "A Y", "B Y", "C Y", "A Z", "B Z", "C Z")

part1 <- function(input) {
  sum(c(4, 1, 7, 8, 5, 2, 3, 9, 6)[match(input, combos)])
}

part2 <- function(input) {
  sum(c(3, 1, 2, 4, 5, 6, 8, 9, 7)[match(input, combos)])
}

test <- function() {
  test_input <- readLines("../inputs/d02-test.txt")
  stopifnot(part1(test_input) == 15)
  stopifnot(part2(test_input) == 12)
}

test()
input <- readLines("../inputs/d02-input.txt")
part1(input)
part2(input)
