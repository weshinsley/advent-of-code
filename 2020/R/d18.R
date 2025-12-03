d <- strsplit(gsub(" ", "", readLines("../inputs/input_18.txt")), "")

calc <- function(d, part2 = FALSE) {
  if (part2) {
    while ("+" %in% d) {
      i <- which(d == "+")[1]
      d[i - 1] <- as.numeric(d[i - 1]) + as.numeric(d[i + 1])
      d <- d[-c(i, i + 1)]
    }
  }
  i <- 1
  r <- as.numeric(d[i])
  while (length(d) > i) {
    r <- ifelse(d[i + 1] == "*", r * as.numeric(d[i + 2]), 
                                 r + as.numeric(d[i + 2]))
    i <- i + 2
  }
  r
}

rewrite <- function(d, part2 = FALSE) {
  while ("(" %in% d) {
    i <- which(d == "(")[1]
    j <- i + 1
    while (d[j] != ")") {
      if (d[j] == "(") {
        i <- j
      }
      j <- j + 1
    }
    d[i] <- calc(d[(i + 1):(j - 1)], part2)
    d <- d[-((i + 1):j)]
  }
  calc(d, part2)
}

options(digits=14)
c(sum(unlist(lapply(d, rewrite))),
  sum(unlist(lapply(d, rewrite, TRUE))))
