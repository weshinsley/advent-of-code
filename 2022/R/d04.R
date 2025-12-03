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

input <- parse("../inputs/input_4.txt")
c(part1(input), part2(input))
