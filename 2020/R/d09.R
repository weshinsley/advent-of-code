library(crayon)

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

test <- as.double(readLines("../Java/d09/test_127_62.txt"))
stopifnot(solve1(test, n = 5, i = 6) == 127)
stopifnot(solve2(test, 127) == 62)

cat(red("\nAdvent of Code 2020 - Day 09\n"))
cat(blue("----------------------------\n\n"))
wes <- as.double(readLines("../Java/d09/wes-input.txt"))
p1 <- solve1(wes)
cat("Part 1:", green(p1), "\n")
cat("Part 2:", green(solve2(wes, p1)), "\n")
