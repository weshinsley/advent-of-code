get_cali <- function(s) {
  i <- as.integer(gsub("[a-z]", "", s))
  cali <- i %% 10
  while (i > 10) {
    i <- i %/% 10
  }
  (i * 10) + cali
}

fix_part2 <- function(s) {
  nums <- c("one", "two", "three", "four", "five", "six",
            "seven", "eight", "nine")
  repls <- c("oonee", "ttwoo", "tthree", "four", "fivee", "six", "sevenn",
             "eeightt", "nninee")
  for (i in seq_along(nums)) {
    s <- gsub(nums[i], i, gsub(nums[i], repls[i], s))
  }
  s
}

part1 <- function(lines) {
  sum(unlist(lapply(lines, get_cali)))
}

part2 <- function(lines) {
  part1(unlist(lapply(lines, fix_part2)))
}

test <- function() {
  stopifnot(part1(readLines("../inputs/d01-test1.txt")) == 142)
  stopifnot(part2(readLines("../inputs/d01-test2.txt")) == 281)
}

test()
input <- readLines("../inputs/d01-input.txt")
part1(input)
part2(input)
