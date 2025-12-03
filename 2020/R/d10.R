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
c(solve1(load("../inputs/input_10.txt")),
  solve2(load("../inputs/input_10.txt")))
