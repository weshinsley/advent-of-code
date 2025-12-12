parse_file <- function(f = "../inputs/input_4.txt") {
  d <- strsplit(readLines(f), "")
  rows <- length(d)
  cols <- length(d[[1]])
  m <- matrix(as.integer(unlist(d) == "@"), nrow = rows, ncol = cols, byrow = TRUE)
  mpad <- matrix(0, nrow = rows + 2, ncol = cols + 2)
  mpad[2:(1+rows), 2:(1+cols)] <- m
  mpad
}

part1 <- function(d) {
  neigh <- d + 10
  for (j in 2:(nrow(d) - 1)) {
    for (i in 2:(ncol(d) - 1)) {
      if (d[j, i] == 1) {
        neigh[j, i] <- d[j-1,i-1]+d[j-1,i]+d[j-1,i+1]+d[j,i-1]+d[j,i+1]+
                       d[j+1,i-1]+d[j+1,i]+d[j+1,i+1]
      }
    }
  }
  list(sum(neigh < 4), neigh)
}

part2 <- function(d) {
  i <- 1
  count <- sum(d == 1)
  res <- part1(d)
  while (res[[1]] > 0) {
    d[res[[2]] < 4] <- 0
    i <- i + 1
    res <- part1(d)
  }
  count - sum(d)
}

d <- parse_file()
c(part1(d)[[1]], part2(d))
