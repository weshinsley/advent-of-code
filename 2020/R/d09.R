valid1 <- function(x, d, top, n) {
  for (i in (top : (top + (n - 1)))) {
    if (x %in% (d[i] + d[((i + 1) : (top + n))])) {
      return(TRUE)
    }
  }
  FALSE
}

solve1 <- function(d, i = 26, n = 25) {
  while (valid1(d[i], d, (i - n), n)) {
    i <- i + 1
  }
  d[i]
}

solve2 <- function(d, target, i = 1, j = 1) {
  s <- d[i]
  while (TRUE) {
    j <- j + 1
    s <- s + d[j]
    while (s > target) {
      s <- s - d[i]
      i <- i + 1
    }
    if (s == target) {
      return(sum(range(d[i:j])))
    }
  }
}

wes <- as.double(readLines("../inputs/input_9.txt"))
p1 <- solve1(wes)
c(p1, solve2(wes,p1))
