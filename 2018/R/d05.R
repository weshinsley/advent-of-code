advent5a <- function(input) {
  i <- 1
  j <- 2
  inlen <- length(input)
  chars <- inlen
  while (j <= inlen) {
    if (abs(input[i] - input[j]) == 32) {
      input[i] <- 0
      input[j] <- 0
      while ((i >= 1) && (input[i] == 0)) {
        i <- i - 1
      }
      i <- max(i, 1)
      j <- j + 1
      chars <- chars - 2
    } else {
      i <- j
      j <- j + 1
    }
  }
  chars
}

advent5b <- function(ascii) {
  best <- Inf
  for (i in 65:97) {
    newinput <- ascii[ascii!=i & ascii!=(i+32)]
    best <- min(best, advent5a(newinput))
  }
  best
}

input <- unlist(strsplit(readLines("../inputs/input_5.txt")[[1]], NULL))
ascii <- unlist(lapply(input, utf8ToInt))
c(advent5a(ascii), advent5b(ascii))
