library(crayon)

valid1 <- function(d) {
  d <- strsplit(d, " ")[[1]]
  char <- substr(d[2], 1, 1)
  xy <- as.integer(strsplit(d[1], "-")[[1]])
  freq <- sum(strsplit(d[3], "")[[1]] == char)
  (freq >= xy[1] & freq <= xy[2])
}

valid2 <- function(d) {
  d <- strsplit(d, " ")[[1]]
  xy <- as.integer(strsplit(d[1], "-")[[1]])
  char <- substr(d[2], 1, 1)
  pwd <- strsplit(d[3], "")[[1]]
  ((pwd[xy[1]] == char) + (pwd[xy[2]] == char) == 1)
}

test <- readLines("../Java/d02/test_2_1.txt")
stopifnot(sum(unlist(lapply(test, valid1))) == 2)
stopifnot(sum(unlist(lapply(test, valid2))) == 1)

wes <- readLines("../Java/d02/wes-input.txt")
cat(red("\nAdvent of Code 2020 - Day 02\n"))
cat(blue("----------------------------\n\n"))
cat("Part 1:", green(sum(unlist(lapply(wes, valid1)))), "\n")
cat("Part 2:", green(sum(unlist(lapply(wes, valid2)))), "\n")
