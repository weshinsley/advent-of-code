parse_file <- function(f = "../inputs/input_1.txt") {
  10000 + cumsum(c(50L, (unlist(lapply(readLines(f), function(x) 
    (if (substr(x, 1, 1) == "L") -1L else 1L) * as.integer(substring(x, 2)))))))
}

part1 <- function(d) {
  sum((d %% 100) == 0)
}

part2 <- function(d) {
  diffy <- function(a, b) {
    abs((b %/% 100) - (a %/% 100)) + 
      if (b < a) ((b %% 100) == 0) - ((a %% 100) == 0) else 0
  }
  sum(unlist(lapply(1 : (length(d) - 1), function(x) diffy(d[x], d[x + 1]))))
}

d <- parse_file()
c(part1(d), part2(d))
