d <- readLines("../inputs/input_15.txt")
pos <- as.integer(substr(d, 13, 14))
t0 <- 0 - as.integer(substr(d, nchar(d) - 1, nchar(d) - 1)) - seq_along(pos)
c(numbers::chinese(t0, pos),
  numbers::chinese(c(t0, -7), c(pos, 11)))
