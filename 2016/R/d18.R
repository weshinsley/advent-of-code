d <- as.integer("." ==
  strsplit(paste0(".", readLines("../inputs/input_18.txt"), "."), "")[[1]])

solve <- function(n) {
  x <- sum(d) - 2
  i <- 1
  while (TRUE) {
    d1 <- d[1:(length(d)-2)] * 4
    d2 <- d[2:(length(d)-1)] * 2
    d3 <- d[3:length(d)]
    d <- c(1, as.integer((d1+d2+d3) %in% c(0, 2, 5, 7)), 1)
    x <- x + sum(d) - 2
    i <- i + 1
    if (i == n) {
      return(x)
    }
  }
}

c(solve(40), solve(400000))
