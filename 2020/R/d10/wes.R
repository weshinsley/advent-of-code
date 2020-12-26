library(crayon)

load <- function(f) {
  d <- sort(as.integer(readLines(f)))
  c(0, d, max(d) + 3)
}

solve1 <- function(d) {
  prod(table(diff(d)))
}
  
solve2 <- function(d) {
  L <- length(d)
  x <- rep(0, L)
  x[2:(L - 1)] <- ifelse( d[3:L] - d[1:(L - 2)] <= 3, 1, 0)
  res <- paste(x, collapse = "")
  res <- gsub("0", "", gsub("1", "2", gsub("11", "4", gsub("111", 7, res))))
  prod(as.numeric(strsplit(res, "")[[1]]))
}

options(digits = 16)

stopifnot(solve1(load("test_35_8.txt")) == 35)
stopifnot(solve2(load("test_35_8.txt")) == 8)
stopifnot(solve1(load("test_220_19208.txt")) == 220)
stopifnot(solve2(load("test_220_19208.txt")) == 19208)

cat(red("\nAdvent of Code 2020 - Day 10\n"))
cat(blue("----------------------------\n\n"))
cat("Part 1:", green(solve1(load("wes-input.txt"))), "\n")
cat("Part 2:", green(solve2(load("wes-input.txt"))), "\n")
