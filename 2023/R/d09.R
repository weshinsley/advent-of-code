parse_input <- function(f) {
  lapply(readLines(f), function(x) as.numeric(strsplit(x, "\\s+")[[1]]))
}

calc <- function(orig, p2) {
  x <- diff(orig)
  d <- list(orig, x)
  while(sum(x) != 0) {
    x <- diff(x)
    d <- c(d, list(x))
  }
  n <- length(d)
  next_val <- 0
  while (n > 1) {
    up <- n - 1
    up_val <- d[[up]][if (p2) 1 else length(d[[up]])]
    next_val <- if (!p2) (up_val + next_val) else (up_val - next_val)
    n <- n - 1
  }
  next_val
}

part1 <- function(d, p2 = FALSE) {
  sum(unlist(lapply(d, calc, p2)))
}

part2 <- function(d) {
  part1(d, TRUE)
}

d <- parse_input("../inputs/input_9.txt")
c(part1(d), part2(d))
