part1 <- function(d, x = 4, i = x) {
  while (i < length(d)) {
    if (anyDuplicated(d[(i - (x - 1)):i]) == 0) return(i)
    i <- i + 1
  }
}

part2 <- function(d) {
  part1(d, 14)
}

test <- function() {
  test2 <- function(x) {
    x <- utf8ToInt(x)
    c(part1(x), part2(x))
  }
  stopifnot(identical(unlist(lapply(readLines("../inputs/d06-test.txt"), test2)),
                      c(7, 19, 5, 23, 6, 23, 10, 29, 11, 26)))
}

test()
d <- utf8ToInt(readLines("../inputs/d06-input.txt"))
part1(d)
part2(d)
