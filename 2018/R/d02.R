advent2a <- function(input) {
  c2 <- 0
  c3 <- 0
  for (s in input) {
    tab <- table(unlist(strsplit(s, NULL)))
    c3 <- c3 + (sum(tab > 2) > 0)
    c2 <- c2 + (sum(tab == 2) > 0)
  }
  
  c2 * c3
}

advent2b <- function(input) {
  nlen <- length(input)
  for (si in seq_len(nlen-1)) {
    x <- strsplit(input[si],"")[[1]]
    for (sj in (si+1):nlen) {
      y <- strsplit(input[sj],"")[[1]]
      if (sum(x != y) == 1) {
        return (paste(x[x == y], collapse=""))
      }
    }
  }
}
  
input <- readLines("../inputs/input_2.txt")
c(advent2a(input), advent2b(input))
