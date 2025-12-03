d <- as.integer(strsplit(readLines("../inputs/input_16.txt"), "")[[1]])

solve <- function(len) {
  L <- length(d)
  while (L < len) {
    d <- c(d, 0, rev(1 - d))
    L <- L + 1 + L
  }
  d <- d[1:len]
  while (length(d) %% 2 == 0) {
    x <- d
    x <- d[1:(length(d)-1)] == d[2:length(d)]
    d <- as.integer(x[seq(1, length(d)-1, by = 2)])
  }
  paste(d, collapse = "")
}

c(solve(272), solve(35651584))
