d <- strsplit(readLines("../inputs/input_10.txt"), "")[[1]]

f <- function(d, n) {
  for (i in seq_len(n - 1)) {
    d <- rle(d)
    d <- c(rbind(d$lengths, d$values))
  }
  d <- rle(d)
  length(d$lengths) + length(d$values)
}

c(f(d, 40), f(d, 50))
