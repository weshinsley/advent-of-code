parse <- function(input) {
  lapply(readLines(input), function(x) {
    bits <- as.integer(strsplit(x, "[,-]")[[1]])
    as.integer(c(((bits[1] <= bits[3]) && (bits[2] >= bits[4])) ||
                 ((bits[3] <= bits[1]) && (bits[4] >= bits[2])),
               length(intersect(bits[1]:bits[2], bits[3]:bits[4])) > 0))
  })
}

part1 <- function(input) {
  sum(unlist(lapply(input, `[[`, 1)))
}

part2 <- function(input) {
  sum(unlist(lapply(input, `[[`, 2)))
}

test <- function(input = parse("../inputs/d04-test.txt")) {
  stopifnot(part1(input) == 2)
  stopifnot(part2(input) == 4)
}

test()
input <- parse("../inputs/d04-input.txt")
part1(input)
part2(input)
